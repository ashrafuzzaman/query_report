require 'spec_helper'
require 'integration_helper'

describe 'column' do
  before do
    @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago, email: 'user1@gmail.com')
    @user2 = User.create(name: 'User#2', age: 20, dob: 20.years.ago, email: 'user2@gmail.com')
  end

  context 'with block' do
    subject do
      reporter(User.scoped) do
        column(:name) { |user| "Hi, #{user.name}" }
      end
    end
    its(:records) { should == [{"Name" => "Hi, User#1"}, {"Name" => "Hi, User#2"}] }
  end

  context 'with option :as' do
    subject do
      reporter(User.scoped) do
        column :name, as: 'The name'
      end
    end
    its(:records) { should == [{"The name" => "User#1"}, {"The name" => "User#2"}] }
  end

  context 'with option :show_total' do
    context 'with the first row as total' do
      subject do
        reporter(User.scoped) do
          column :age, show_total: true
          column :name
        end
      end
      its(:column_total_with_colspan) { should == [{:content => 30.0, :align => :right}, {:content => "", :colspan => 1}] }
    end

    context 'with the first row as total' do
      subject do
        reporter(User.scoped) do
          column :name
          column :age, show_total: true
        end
      end
      its(:column_total_with_colspan) { should == [{:content => "Total"}, {:content => 30.0, :align => :right}] }
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
      subject do
        reporter(User.scoped) do
          column :name, rowspan: true
          column :email, rowspan: true
        end
      end
      its(:records_with_rowspan) { should == [{"Name" => {:content => "User#1", :rowspan => 2}, "Email" => {:content => "user1@gmail.com", :rowspan => 1}},
                                              {"Email" => {:content => "user11@gmail.com", :rowspan => 2}},
                                              {"Name" => {:content => "User#2", :rowspan => 2}}, {"Email" => {:content => "user2@gmail.com", :rowspan => 1}}] }
    end

    context 'with rowspan with relative column' do
      subject do
        reporter(User.scoped) do
          column :name, rowspan: true
          column :email, rowspan: :name
        end
      end
      its(:records_with_rowspan) { should == [{"Name" => {:content => "User#1", :rowspan => 2}, "Email" => {:content => "user1@gmail.com", :rowspan => 1}},
                                              {"Email" => {:content => "user11@gmail.com", :rowspan => 1}},
                                              {"Name" => {:content => "User#2", :rowspan => 2}, "Email" => {:content => "user11@gmail.com", :rowspan => 1}},
                                              {"Email" => {:content => "user2@gmail.com", :rowspan => 1}}] }
    end
  end

  context 'with option :only_on_web' do
    subject do
      reporter(User.scoped) do
        column :name, only_on_web: true
        column :age
      end
    end
    its(:records) { should == [{"Age" => 10, "Name" => "User#1"}, {"Age" => 20, "Name" => "User#2"}] }
    its(:all_records) { should == [{"Age" => 10}, {"Age" => 20}] } #should not render the name column
  end
end