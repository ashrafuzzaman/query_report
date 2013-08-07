require 'spec_helper'
require 'query_report/column'
require 'fake/active_record/models'

describe QueryReport::ColumnModule do
  class DummyClass
    include QueryReport::ColumnModule
  end
  let(:object) { DummyClass.new }
  before do
    object.columns = []
    object.stub(:model_class).and_return(Readership)
  end

  context 'defined columns' do
    it 'detects type' do
      object.column :user_id
      column = object.columns.first
      column.name.should be :user_id
      column.type.should be :integer
    end
  end

  context 'custom columns' do
    it 'supports to define column with type' do
      object.column :user, type: :integer do |obj|
        link_to obj.user.name, obj.user
      end

      column = object.columns.first
      column.name.should be :user
      column.type.should be :integer
      column.data.should_not be nil
    end
  end

  describe '#humanize' do
    it 'supports rails human_attribute_name' do
      object.column :user_id
      object.columns.first.humanize.should == 'User'
    end

    it 'supports custom column name' do
      object.column :user_id, as: 'Admin'
      object.columns.first.humanize.should == 'Admin'
    end
  end

  describe '#value' do
    it 'fetches property value' do
      object.column :user_id
      record = Readership.new(user_id: 1)
      object.columns.first.value(record).should == 1
    end

    it 'fetches value with the block given' do
      user = User.create(name: 'Jitu', age: 30)
      record = Readership.create!(user_id: user.id)
      object.column :user, type: :string do |obj|
        "#{obj.user.name} is @#{obj.user.age}"
      end
      object.columns.first.value(record).should == 'Jitu is @30'
    end
  end
end