require 'spec_helper'
require 'query_report/filter'

describe QueryReport::FilterModule do
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
        filter.custom?.should be false
      end

      it 'should be able to filter with type date' do
        @object.filter(:created_at, type: :date)
        filter = @object.filters.first

        filter.column.should be :created_at
        filter.type.should be :date
        filter.custom?.should be false
      end

      it 'should be able to filter with type other types which does not have custom query' do
        @object.filter(:user_id, type: :user)
        filter = @object.filters.first

        filter.column.should be :user_id
        filter.type.should be :user
        filter.comparators.keys.should =~ [:eq]
        filter.comparators.values.should =~ [I18n.t('query_report.filters.user_id.equals')]
        filter.custom?.should be false
      end
    end

    it 'should be able to add custom filter' do
      @object.filter(:user_id, type: :user_auto_complete, comp: {eq: 'Filter user'}) do |query, user_id|
        query.where(user_id: user_id)
      end
      filter = @object.filters.first

      filter.column.should be :user_id
      filter.type.should be :user_auto_complete
      filter.comparators.keys.should =~ [:eq]
      filter.comparators.values.should =~ ['Filter user']
      filter.custom?.should be true
    end

    describe 'detect comparators' do
      it 'should be able detect for text type' do
        @object.filter(:created_at, type: :text)

        filter = @object.filters.first
        filter.comparators.keys.should =~ [:cont]
        filter.comparators.values.should =~ [I18n.t('query_report.filters.created_at.contains')]
      end

      it 'should be able detect for date type' do
        @object.filter(:created_at, type: :date)

        filter = @object.filters.first
        filter.comparators.keys.should =~ [:gteq, :lteq]
        filter.comparators.values.should =~ [I18n.t('query_report.filters.from'), I18n.t('query_report.filters.to')]
      end

      it 'should set eq as default type' do
        @object.filter :created_at

        filter = @object.filters.first
        filter.comparators.keys.should =~ [:eq]
        filter.comparators.values.should =~ [I18n.t("query_report.filters.created_at.equals")]
      end
    end
  end
end