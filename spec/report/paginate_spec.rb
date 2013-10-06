require 'spec_helper'
require 'kaminari'
require 'query_report/paginate'

describe QueryReport::PaginateModule do
  class DummyClass
    include QueryReport::PaginateModule

    def paginate?
      true
    end
  end

  let(:object) { DummyClass.new }

  it 'applies pagination' do
    query = Object.new
    query.stub(:page)
    query.should_receive(:page).with(25)
    object.apply_pagination(query, page: 25)
  end
end