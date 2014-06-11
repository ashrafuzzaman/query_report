require 'spec_helper'
require 'integration_helper'

describe 'column' do
  let(:user_aged_10) { User.create(name: 'User#1', age: 10, dob: 10.years.ago, email: 'user1@gmail.com') }
  let(:user_aged_20) { User.create(name: 'User#2', age: 20, dob: 20.years.ago, email: 'user2@gmail.com') }

  before do
    user_aged_10 && user_aged_20
  end

  context 'with block' do
    subject(:report) do
      reporter(User.scoped) do
        column(:name) { |user| "Hi, #{user.name}" }
      end
    end
    it("returns records") { expect(report.records).to eq [{"Name" => "Hi, #{user_aged_10.name}"}, {"Name" => "Hi, #{user_aged_20.name}"}] }
  end

  context 'with option :as' do
    subject(:report) do
      reporter(User.scoped) do
        column :name, as: 'The name'
      end
    end
    it("returns records") { expect(report.records).to eq [{"The name" => user_aged_10.name}, {"The name" => user_aged_20.name}] }
  end

  context 'with option :show_total' do
    context 'with the first row as total' do
      subject(:report) do
        reporter(User.scoped) do
          column :age, show_total: true
          column :name
        end
      end
      it("returns records with colspan") do
        expect(report.column_total_with_colspan).to eq [{:content => 30.0, :align => :right}, {:content => "", :colspan => 1}]
      end
    end

    context 'with the first row as total' do
      subject(:report) do
        reporter(User.scoped) do
          column :name
          column :age, show_total: true
        end
      end
      it("returns records with colspan") do
        expect(report.column_total_with_colspan).to eq [{:content => "Total"}, {:content => 30.0, :align => :right}]
      end
    end
  end

  context 'with option :rowspan' do
    before do
      User.scoped.destroy_all
      User.create(name: 'User#1', email: 'user1@gmail.com')
      User.create(name: 'User#1', email: 'user11@gmail.com')
      User.create(name: 'User#2', email: 'user11@gmail.com')
      User.create(name: 'User#2', email: 'user2@gmail.com')
    end

    context 'with rowspan set to true for both column' do
      subject(:report) do
        reporter(User.scoped) do
          column :name, rowspan: true
          column :email, rowspan: true
        end
      end
      it("returns record to render") do
        expect(report.records_to_render).to eq [{"Name" => {:content => 'User#1', :rowspan => 2},
                                                 "Email" => {:content => "user1@gmail.com", :rowspan => 1}},
                                                {"Email" => {:content => "user11@gmail.com", :rowspan => 2}},
                                                {"Name" => {:content => 'User#2', :rowspan => 2}}, {"Email" => {:content => "user2@gmail.com", :rowspan => 1}}]
      end
    end

    context 'with rowspan with relative column' do
      subject(:report) do
        reporter(User.scoped) do
          column :name, rowspan: true
          column :email, rowspan: :name
        end
      end
      it("returns record to render") do
        expect(report.records_to_render).to eq [{"Name" => {:content => 'User#1', :rowspan => 2}, "Email" => {:content => "user1@gmail.com", :rowspan => 1}},
                                                {"Email" => {:content => "user11@gmail.com", :rowspan => 1}},
                                                {"Name" => {:content => 'User#2', :rowspan => 2}, "Email" => {:content => "user11@gmail.com", :rowspan => 1}},
                                                {"Email" => {:content => "user2@gmail.com", :rowspan => 1}}]
      end
    end
  end

  context 'with option :only_on_web' do
    subject(:report) do
      reporter(User.scoped) do
        column :name, only_on_web: true
        column :age
      end
    end
    it("returns records") do
      expect(report.records).to eq [{"Age" => 10, "Name" => 'User#1'}, {"Age" => 20, "Name" => 'User#2'}]
    end
    it("returns records with out pagination for all records") do
      expect(report.all_records).to eq [{"Age" => 10}, {"Age" => 20}] #should not render the name column
    end
  end

  context 'with pdf options' do
    context 'with width' do
      subject(:report) do
        reporter(User.scoped) do
          column :name, pdf: {width: 100}
          column :age
        end
      end

      it { expect(report.columns.first.pdf_options[:width]).to be 100 }
    end
  end
end