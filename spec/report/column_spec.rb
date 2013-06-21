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
    DummyActiveRecordClass.stub(:columns_hash).and_return({'name' => stub(type: :string)})

    @object.stub(:model_class).and_return(DummyActiveRecordClass)
    @object.columns = []

    @object.column :name
    @object.columns.size.should == 1
    column = @object.columns.first
    column.name.should be(:name)
    column.type.should be(:string)
  end
end