require 'spec_helper'
require 'integration_helper'

describe 'column' do
  before do
    @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago)
  end

  context 'with option :as' do
    subject do
      reporter(User.scoped) do
        column :name, as: 'The name'
      end
    end
    its(:records) { should == [{'The name' => @user1.name}] }
  end
end