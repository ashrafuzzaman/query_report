require 'spec_helper'
require 'integration_helper'

describe 'column' do
  before do
    @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago)
    @user2 = User.create(name: 'User#2', age: 20, dob: 20.years.ago)
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
end