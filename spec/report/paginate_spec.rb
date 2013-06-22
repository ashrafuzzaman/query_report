require 'spec_helper'
require 'kaminari'
require 'query_report/paginate'

describe QueryReport::PaginateModule do
  class DummyClass
    include QueryReport::PaginateModule
  end

  before(:each) do
    @object = DummyClass.new
  end

  it 'should apply pagination' do
    query = Object.new
    query.stub(:page)
    query.should_receive(:page).with(25)
    @object.apply_pagination(query, page: 25)
  end
end