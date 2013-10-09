require 'spec_helper'
require 'query_report/filter'
require 'query_report/comparator'

describe QueryReport::FilterModule::Comparator do
  context 'without default value' do
    context 'with date type' do
      let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) }
      subject { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

      its(:search_key) { should be :created_at_gteq }
      its(:search_tag_name) { should == 'q[created_at_gteq]' }
      its(:param_value) { should be nil }
      its(:has_default?) { should be false }
      its(:stringified_default) { should be nil }
      its(:objectified_param_value) { should be nil }
    end

    context 'with custom date type' do
      let(:filter) do
        QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) do |query, from, to|
          query.where('from > ? and to < ?', from, to)
        end
      end
      subject { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

      its(:search_tag_name) { should == 'custom_search[created_at_gteq]' }
    end

    context 'with datetime type' do
      let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :datetime}) }
      subject { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

      its(:search_key) { should be :created_at_gteq }
      its(:search_tag_name) { should == 'q[created_at_gteq]' }
      its(:param_value) { should be nil }
      its(:has_default?) { should be false }
      its(:stringified_default) { should be nil }
      its(:objectified_param_value) { should be nil }
    end

    context 'with custom datetime type' do
      let(:filter) do
        QueryReport::FilterModule::Filter.new({}, :created_at, {type: :datetime}) do |query, from, to|
          query.where('from > ? and to < ?', from, to)
        end
      end
      subject { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date') }

      its(:search_tag_name) { should == 'custom_search[created_at_gteq]' }
    end
  end

  context 'with default value' do
    context 'with date type' do
      let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) }
      let(:default_value) { Date.current }
      let(:default_value_str) { I18n.l(Date.current, format: QueryReport.config.datetime_format) }
      subject { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date', default_value) }

      its(:param_value) { should == default_value_str }
      its(:has_default?) { should be true }
      its(:stringified_default) { should == default_value_str }
      its(:objectified_param_value) { should == default_value }
    end

    context 'with datetime type' do
      let(:filter) { QueryReport::FilterModule::Filter.new({}, :created_at, {type: :date}) }
      let(:default_value) { Date.current }
      let(:default_value_str) { I18n.l(default_value, format: QueryReport.config.datetime_format) }
      subject { QueryReport::FilterModule::Comparator.new(filter, :gteq, 'From date', default_value) }

      its(:param_value) { should == default_value_str }
      its(:has_default?) { should be true }
      its(:stringified_default) { should == default_value_str }
      its(:objectified_param_value) { should == Date.current }
    end

    context 'with datetime type' do
      let(:filter) { QueryReport::FilterModule::Filter.new({}, :name, {type: :text}) }
      let(:default_value) { 'Ashraf' }
      let(:default_value_str) { default_value }
      subject { QueryReport::FilterModule::Comparator.new(filter, :eq, 'Name', default_value) }

      its(:param_value) { should == default_value_str }
      its(:has_default?) { should be true }
      its(:stringified_default) { should == default_value_str }
      its(:objectified_param_value) { should == default_value }
    end
  end
end