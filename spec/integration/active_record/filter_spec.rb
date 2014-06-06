require 'spec_helper'
require 'integration_helper'

describe 'filter' do
  before do
    @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago)
    @user2 = User.create(name: 'User#2', age: 20, dob: 20.years.ago)
    @user3 = User.create(name: 'User#3', age: 34)
  end

  context 'without any filter applied' do
    subject do
      reporter(User.scoped) do
        filter :dob, type: :datetime, default: [21.years.ago, 1.months.from_now]
        column :name
      end
    end
    its(:records) { should == [{'Name' => @user1.name}, {'Name' => @user2.name}] }
  end

  context 'with sorting applied' do
    context 'with ASC sorting' do
      subject do
        reporter(User.scoped, {q: {s: 'age ASC'}}) do
          filter :age
          column :name
        end
      end
      its(:records) { should == [{'Name' => @user1.name}, {'Name' => @user2.name}, {'Name' => @user3.name}] }
    end

    context 'with DESC sorting' do
      subject do
        reporter(User.scoped, {q: {s: 'age DESC'}}) do
          column :age
        end
      end
      its(:records) { should == [{'Age' => 34}, {'Age' => 20}, {'Age' => 10}] }
    end
  end

  context 'with filter applied' do
    subject do
      reporter(User.scoped, {q: {age_eq: '34'}}) do
        column :age
      end
    end
    its(:records) { should == [{'Age' => 34}] }
  end
end