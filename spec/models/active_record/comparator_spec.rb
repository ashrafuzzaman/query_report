require 'spec_helper'
require 'query_report/filter_module/dsl'
require 'query_report/filter_module/comparator'

if defined? ActiveRecord
  describe QueryReport::FilterModule::Comparator do
    context 'without default value' do
      context 'with date type' do
        let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) }
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

        it("returns search_key") { expect(comparator.search_key).to be :created_at_gteq }
        it("returns search_tag_name") { expect(comparator.search_tag_name).to eq 'q[created_at_gteq]' }
        it("returns param_value") { expect(comparator.param_value).to be nil }
        it("returns has_default?") { expect(comparator.has_default?).to be false }
        it("returns stringified_default") { expect(comparator.stringified_default).to be nil }
        it("returns objectified_param_value") { expect(comparator.objectified_param_value).to be nil }
      end

      context 'with custom date type' do
        let(:filter) do
          QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) do |query, from, to|
            query.where('from > ? and to < ?', from, to)
          end
        end
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

        it("returns search_tag_name") { expect(comparator.search_tag_name).to eq 'custom_search[created_at_gteq]' }
      end

      context 'with datetime type' do
        let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :datetime}) }
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

        it("returns search_key") { expect(comparator.search_key).to be :created_at_gteq }
        it("returns search_tag_name") { expect(comparator.search_tag_name).to eq 'q[created_at_gteq]' }
        it("returns param_value") { expect(comparator.param_value).to be nil }
        it("returns has_default?") { expect(comparator.has_default?).to be false }
        it("returns stringified_default") { expect(comparator.stringified_default).to be nil }
        it("returns objectified_param_value") { expect(comparator.objectified_param_value).to be nil }
      end

      context 'with custom datetime type' do
        let(:filter) do
          QueryReport::FilterModule::Filter.new({}, :created_at, {type: :datetime}) do |query, from, to|
            query.where('from > ? and to < ?', from, to)
          end
        end
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

        it("returns search_tag_name") { expect(comparator.search_tag_name).to eq 'custom_search[created_at_gteq]' }
      end
    end

    context 'with default value' do
      context 'with date type' do
        let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) }
        let(:default_value) { Date.current }
        let(:default_value_str) { I18n.l(Date.current, format: QueryReport.config.datetime_format) }
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date', default_value) }

        it("returns param_value") { expect(comparator.param_value).to eq default_value_str }
        it("returns has_default?") { expect(comparator.has_default?).to be true }
        it("returns stringified_default") { expect(comparator.stringified_default).to eq default_value_str }
        it("returns objectified_param_value") { expect(comparator.objectified_param_value).to eq default_value }
      end

      context 'with datetime type' do
        let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) }
        let(:default_value) { Date.current }
        let(:default_value_str) { I18n.l(default_value, format: QueryReport.config.datetime_format) }
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date', default_value) }

        it("returns param_value") { expect(comparator.param_value).to eq default_value_str }
        it("returns has_default?") { expect(comparator.has_default?).to be true }
        it("returns stringified_default") { expect(comparator.stringified_default).to eq default_value_str }
        it("returns objectified_param_value") { expect(comparator.objectified_param_value).to eq Date.current }
      end

      context 'with datetime type' do
        let(:filter) { QueryReport::FilterModule::Filter.new({}, :name, {type: :text}) }
        let(:default_value) { 'Ashraf' }
        let(:default_value_str) { default_value }
        subject(:comparator) { QueryReport::FilterModule::Comparator.new(filter, :eq, 'Name', default_value) }

        it("returns param_value") { expect(comparator.param_value).to eq default_value_str }
        it("returns has_default?") { expect(comparator.has_default?).to be true }
        it("returns stringified_default") { expect(comparator.stringified_default).to eq default_value_str }
        it("returns objectified_param_value") { expect(comparator.objectified_param_value).to eq default_value }
      end
    end
  end
end