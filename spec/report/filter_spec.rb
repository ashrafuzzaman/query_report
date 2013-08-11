require 'spec_helper'
require 'query_report/filter'

describe QueryReport::FilterModule do
  class DummyClass
    include QueryReport::FilterModule
  end

  let(:object) { DummyClass.new }

  describe 'supported list' do
    subject { QueryReport::FilterModule::Filter }
    its(:supported_types) { should =~ [:date, :boolean, :text] }
  end

  describe 'supported types' do
    context 'with text type' do
      subject do
        object.filter(:created_at, type: :text)
        object.filters.first
      end

      its(:column) { should be :created_at }
      its(:type) { should be :text }
      its(:custom?) { should be false }
    end

    context 'with date type' do
      subject do
        object.filter(:created_at, type: :date)
        object.filters.first
      end

      its(:column) { should be :created_at }
      its(:type) { should be :date }
      its(:custom?) { should be false }
    end

    context 'with type default' do
      subject do
        object.filter(:user_id, type: :user)
        object.filters.first
      end

      its(:column) { should be :user_id }
      its(:type) { should be :user }
      its(:custom?) { should be false }

      it 'has proper comparators' do
        comps = subject.comparators
        comps.collect(&:type).should =~ [:eq]
        comps.collect(&:name).should =~ [I18n.t('query_report.filters.user_id.equals')]
      end
    end
  end

  context 'custom filter' do
    it 'filters with given block' do
      object.filter(:user_id, type: :user_auto_complete, comp: {eq: 'Filter user'}) do |query, user_id|
        query.where(user_id: user_id)
      end
      filter = object.filters.first

      filter.column.should be :user_id
      filter.type.should be :user_auto_complete
      filter.comparators.collect(&:type).should =~ [:eq]
      filter.comparators.collect(&:name).should =~ ['Filter user']
      filter.custom?.should be true
    end
  end

  describe 'detect comparators' do
    it 'detects for text type' do
      object.filter(:created_at, type: :text)

      filter = object.filters.first
      filter.comparators.collect(&:type).should =~ [:cont]
      filter.comparators.collect(&:name).should =~ [I18n.t('query_report.filters.created_at.contains')]
    end

    it 'detects for date type' do
      object.filter(:created_at, type: :date)

      filter = object.filters.first
      filter.comparators.collect(&:type).should =~ [:gteq, :lteq]
      filter.comparators.collect(&:name).should =~ [I18n.t('query_report.filters.from'), I18n.t('query_report.filters.to')]
    end

    it 'sets default comparator' do
      object.filter :created_at

      filter = object.filters.first
      filter.comparators.collect(&:type).should =~ [:eq]
      filter.comparators.collect(&:name).should =~ [I18n.t("query_report.filters.created_at.equals")]
    end
  end

  it 'supports initial filter value' do
    from = 1.weeks.ago
    to = Time.now
    object.filter(:created_at, type: :date, default: [from, to])
    filter = object.filters.first

    expect(filter.column).to be :created_at
    expect(filter.type).to be :date

    from_comp = filter.comparators.first
    expect(from_comp.type).to be :gteq
    expect(from_comp.has_default?).to be true
  end
end