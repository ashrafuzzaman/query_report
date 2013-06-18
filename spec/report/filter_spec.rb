require 'spec_helper'
require 'query_report/report'
require 'query_report/filter'

describe QueryReport::Report do
  class DummyClass
    include QueryReport::FilterModule
  end

  before(:each) do
    @object = DummyClass.new
  end

  describe 'filter' do
    it 'should have date and text in the supported list' do
      QueryReport::FilterModule::Filter.supported_types.should =~ [:date, :text]
    end

    describe 'with supported types' do
      it 'should be able to filter with type text' do
        @object.filter(:created_at, type: :text)
        @object.filters.size.should be 1
        filter = @object.filters.first

        filter.column.should be :created_at
        filter.type.should be :text
        filter.comparators.should =~ [:eq]
        filter.custom?.should be false
      end
    end

    it 'should be able to add custom filter with one arity' do
      @object.filter(:user_id, type: :user, comp: :text) do |query, user_id|
        query.where(user_id: user_id)
      end

      filter = @object.filters.first
    end

  end
end