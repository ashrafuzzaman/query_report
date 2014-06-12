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

      allow(query).to receive(:page).and_return(query)
      allow(query).to receive(:per).and_return(query)

      expect(query).to receive(:page).with(25)
      expect(query).to receive(:per).with(10)
      object.apply_pagination(query, page: 25)
    end
  end
end