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
    it 'should be able to add filter with supported types' do
      [:text, :date].each { |type| @object.filter(:created_at, type: type) }
      @object.filters.size.should be 2
    end
  end
end