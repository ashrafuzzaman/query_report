require 'spec_helper'
require 'query_report/filter'

if defined? ActiveRecord
  describe QueryReport::FilterModule do
    class DummyClass
      include QueryReport::FilterModule
    end

    let(:object) { DummyClass.new }

    describe 'supported list' do
      subject(:filter) { QueryReport::FilterModule::Filter }
      it("returns supported_types") { expect(filter.supported_types).to match_array [:date, :datetime, :boolean, :text] }
    end

    describe 'supported types' do
      context 'with text type' do
        subject(:filter) do
          object.filter(:created_at, type: :text)
          object.filters.first
        end

        it("returns column") { expect(filter.column).to be :created_at }
        it("returns type") { expect(filter.type).to be :text }
        it("returns custom?") { expect(filter.custom?).to be false }
        it("returns params_key") { expect(filter.params_key).to be :q }

        it 'has proper comparators' do
          comps = subject.comparators
          expect(comps.collect(&:type)).to match_array [:cont]
          expect(comps.collect(&:name)).to match_array [I18n.t('query_report.filters.created_at.contains')]
          expect(comps.collect(&:search_key)).to match_array [:created_at_cont]
          expect(comps.collect(&:search_tag_name)).to match_array ['q[created_at_cont]']
        end
      end

      context 'with date type' do
        subject(:filter) do
          object.filter(:created_at, type: :date)
          object.filters.first
        end

        it("returns column") { expect(filter.column).to be :created_at }
        it("returns type") { expect(filter.type).to be :date }
        it("returns custom?") { expect(filter.custom?).to be false }
        it("returns params_key") { expect(filter.params_key).to be :q }

        it 'has proper comparators' do
          comps = subject.comparators
          expect(comps.collect(&:type)).to match_array [:gteq, :lteq]
          expect(comps.collect(&:name)).to match_array [I18n.t('query_report.filters.from'), I18n.t('query_report.filters.to')]
          expect(comps.collect(&:search_key)).to match_array [:created_at_gteq, :created_at_lteq]
          expect(comps.collect(&:search_tag_name)).to match_array ['q[created_at_gteq]', 'q[created_at_lteq]']
        end
      end

      context 'with datetime type' do
        subject(:filter) do
          object.filter(:created_at, type: :datetime)
          object.filters.first
        end

        it("returns column") { expect(filter.column).to be :created_at }
        it("returns type") { expect(filter.type).to be :datetime }
        it("returns custom?") { expect(filter.custom?).to be false }
        it("returns params_key") { expect(filter.params_key).to be :q }

        it 'has proper comparators' do
          comps = subject.comparators
          expect(comps.collect(&:type)).to match_array [:gteq, :lteq]
          expect(comps.collect(&:name)).to match_array [I18n.t('query_report.filters.from'), I18n.t('query_report.filters.to')]
          expect(comps.collect(&:search_key)).to match_array [:created_at_gteq, :created_at_lteq]
          expect(comps.collect(&:search_tag_name)).to match_array ['q[created_at_gteq]', 'q[created_at_lteq]']
        end
      end

      context 'with type default' do
        subject(:filter) do
          object.filter(:user_id, type: :user)
          object.filters.first
        end

        it("returns column") { expect(filter.column).to be :user_id }
        it("returns type") { expect(filter.type).to be :user }
        it("returns custom?") { expect(filter.custom?).to be false }
        it("returns params_key") { expect(filter.params_key).to be :q }

        it 'has proper comparators' do
          comps = subject.comparators
          expect(comps.collect(&:type)).to match_array [:eq]
          expect(comps.collect(&:name)).to match_array [I18n.t('query_report.filters.user_id.equals')]
          expect(comps.collect(&:search_key)).to match_array [:user_id_eq]
          expect(comps.collect(&:search_tag_name)).to match_array ['q[user_id_eq]']
        end
      end
    end

    context 'with custom filter' do
      subject(:filter) do
        object.filter(:user_id, type: :user_auto_complete, comp: {eq: 'Filter user'}) do |query, user_id|
          query.where(user_id: user_id)
        end
        object.filters.first
      end

      it("returns column") { expect(filter.column).to be :user_id }
      it("returns type") { expect(filter.type).to be :user_auto_complete }
      it("returns custom?") { expect(filter.custom?).to be true }
      it("returns params_key") { expect(filter.params_key).to be :custom_search }

      it 'has given comparator' do
        comps = subject.comparators
        expect(comps.collect(&:type)).to match_array [:eq]
        expect(comps.collect(&:name)).to match_array ['Filter user']
        expect(comps.collect(&:search_key)).to match_array [:user_id_eq]
        expect(comps.collect(&:search_tag_name)).to match_array ['custom_search[user_id_eq]']
      end
    end

    describe 'default values' do
      context 'with date type' do
        subject(:filter) do
          object.filter(:created_at, type: :date, default: [1.weeks.ago, Time.zone.now])
          object.filters.first
        end

        it("returns column") { expect(filter.column).to be :created_at }
        it("returns type") { expect(filter.type).to be :date }

        it 'has proper comparator' do
          comps = subject.comparators
          expect(comps.collect(&:type)).to match_array [:lteq, :gteq]
          expect(comps.first.has_default?).to be true
        end
      end

      context 'with boolean type' do
        subject(:filter) do
          object.filter(:created_at, type: :date, default: [1.weeks.ago, Time.zone.now])
          object.filter(:paid, type: :boolean, default: false)
          object.filters.last
        end

        it("returns column") { expect(filter.column).to be :paid }
        it("returns type") { expect(filter.type).to be :boolean }

        it 'has proper comparator' do
          comps = subject.comparators
          expect(comps.collect(&:type)).to match_array [:eq]
          expect(comps.first.has_default?).to be true
          expect(comps.first.default).to eq false
        end
      end
    end

    describe '#has_filter?' do
      context 'with filters' do
        subject(:filter) do
          object.filter(:created_at, type: :date)
          object
        end

        it("returns has_filter?") { expect(filter.has_filter?).to be true }
      end

      context 'with out filters' do
        subject(:filter) { object }
        it("returns has_filter?") { expect(filter.has_filter?).to be false }
      end
    end
  end
end