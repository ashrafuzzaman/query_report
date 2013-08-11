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

      it 'has proper comparators' do
        comps = subject.comparators
        comps.collect(&:type).should =~ [:cont]
        comps.collect(&:name).should =~ [I18n.t('query_report.filters.created_at.contains')]
      end
    end

    context 'with date type' do
      subject do
        object.filter(:created_at, type: :date)
        object.filters.first
      end

      its(:column) { should be :created_at }
      its(:type) { should be :date }
      its(:custom?) { should be false }

      it 'has proper comparators' do
        comps = subject.comparators
        comps.collect(&:type).should =~ [:gteq, :lteq]
        comps.collect(&:name).should =~ [I18n.t('query_report.filters.from'), I18n.t('query_report.filters.to')]
      end
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

  context 'with custom filter' do
    subject do
      object.filter(:user_id, type: :user_auto_complete, comp: {eq: 'Filter user'}) do |query, user_id|
        query.where(user_id: user_id)
      end
      object.filters.first
    end

    its(:column) { should be :user_id }
    its(:type) { should be :user_auto_complete }
    its(:custom?) { should be true }

    it 'has given comparator' do
      comps = subject.comparators
      comps.collect(&:type).should =~ [:eq]
      comps.collect(&:name).should =~ ['Filter user']
    end
  end

  context 'with date type and default values' do
    subject do
      object.filter(:created_at, type: :date, default: [1.weeks.ago, Time.zone.now])
      object.filters.first
    end

    its(:column) { should be :created_at }
    its(:type)   { should be :date }

    it 'has proper comparator' do
      comps = subject.comparators
      comps.collect(&:type).should =~ [:lteq, :gteq]
      expect(comps.first.has_default?).to be true
    end
  end
end