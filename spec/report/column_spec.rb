require 'spec_helper'
require 'query_report/column'

describe QueryReport::ColumnModule do
  class DummyActiveRecordClass
  end

  class DummyClass
    include QueryReport::ColumnModule
  end

  before(:each) do
    @object = DummyClass.new
  end

  it 'should support to define columns' do
    DummyActiveRecordClass.stub(:columns_hash).and_return({'user_id' => stub(type: :integer)})
    @object.stub(:model_class).and_return(DummyActiveRecordClass)
    @object.columns = []

    @object.column :user_id

    column = @object.columns.first
    column.name.should be :user_id
    column.type.should be :integer
  end

  it 'should support to define columns with custom definition' do
    DummyActiveRecordClass.stub(:columns_hash).and_return({})
    @object.stub(:model_class).and_return(DummyActiveRecordClass)
    @object.columns = []

    @object.column :user, type: :integer do |obj|
      link_to obj.user.name, obj.user
    end

    column = @object.columns.first
    column.name.should be :user
    column.type.should be :integer
    column.data.should_not be nil
  end

  describe 'humanize' do
    before(:each) do
      DummyActiveRecordClass.stub(:columns_hash).and_return({})
      DummyActiveRecordClass.stub(:human_attribute_name).and_return('User')
      @object.stub(:model_class).and_return(DummyActiveRecordClass)
      @object.columns = []
    end

    it 'should support the built in rails human_attribute_name' do
      @object.column :user_id
      @object.columns.first.humanize.should == 'User'
    end

    it 'should support the override with as param' do
      @object.column :user_id, as: 'Admin'
      @object.columns.first.humanize.should == 'Admin'
    end
  end
end