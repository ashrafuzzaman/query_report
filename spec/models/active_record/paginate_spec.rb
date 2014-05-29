require 'spec_helper'
require 'kaminari'
require 'query_report/paginate'

if defined? ActiveRecord
  describe QueryReport::PaginateModule do
    class DummyClass
      attr_accessor :options
      include QueryReport::PaginateModule

      def paginate?
        true
      end
    end

    let(:object) { DummyClass.new }

    it 'applies pagination' do
      query = Object.new
      object.options = {per_page: 10}
      query.stub(:page) { query }
      query.stub(:per) { query }
      query.should_receive(:page).with(25)
      query.should_receive(:per).with(10)
      object.apply_pagination(query, page: 25)
    end
  end
end