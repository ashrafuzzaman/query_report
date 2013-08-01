require 'spec_helper'
require 'query_report/helper'

Temping.create :dummy_invoice do
  with_columns do |t|
    t.string :title
    t.float :total_paid, :total_charged
    t.boolean :paid
    t.date :created_at
  end

  attr_accessible :title, :total_charged, :total_paid, :paid
end

class DummyInvoiceController
  attr_accessor :params, :view_context
  include QueryReport::Helper

  def initialize
    @params = {}
    @view_context = Object.new
    #@view_context.define_method(:link_to) do |text, *args|
    #  text
    #end
  end

  def render_report #override the existing renderer
  end

  #def index
  #  @invoices = DummyInvoice.scoped
  #
  #  reporter(@invoices) do
  #    filter :title, type: :text
  #    filter :created_at, type: :date
  #
  #    column :title do |invoice|
  #      #link_to invoice.title, invoice
  #      invoice.title
  #    end
  #    column :total_paid
  #    column :total_charged
  #    column :paid
  #
  #    column_chart('Unpaid VS Paid') do
  #      add 'Unpaid' do |query|
  #        query.sum('total_charged').to_f - query.sum('total_paid').to_f
  #      end
  #      add 'Paid' do |query|
  #        query.sum('total_paid').to_f
  #      end
  #    end
  #  end
  #end
end

describe DummyInvoiceController do
  before(:each) do
    DummyInvoice.scoped.destroy_all
    @inv1 = DummyInvoice.create(title: 'Invoice#1', total_charged: 100, total_paid: 100, paid: true)
    @inv2 = DummyInvoice.create(title: 'Invoice#2', total_charged: 200, total_paid: 80, paid: false)
    @inv3 = DummyInvoice.create(title: 'Invoice#3', total_charged: 340, total_paid: 12.5, paid: false)
  end

  it "should only show selected columns with readable names" do
    class DummyInvoiceController
      def index_with_readable_names
        @invoices = DummyInvoice.scoped
        reporter(@invoices) do
          column :title
          column :total_paid
        end
      end
    end

    controller = DummyInvoiceController.new
    controller.index_with_readable_names
    report = controller.instance_eval { @report }
    report.records.should == [{'Title' => @inv1.title, 'Total paid' => @inv1.total_paid},
                              {'Title' => @inv2.title, 'Total paid' => @inv2.total_paid},
                              {'Title' => @inv3.title, 'Total paid' => @inv3.total_paid}]
  end

  context 'filter' do
    class DummyInvoiceController
      def index_with_default_filter
        @invoices = DummyInvoice.scoped
        reporter(@invoices) do
          filter :paid, default: ''
          filter :created_at, type: :date, default: [5.months.ago.to_date.to_s(:db), 1.months.from_now.to_date.to_s(:db)]

          column :title
          column :total_paid
        end
      end
    end

    it "should initialize without any filter applied" do
      controller = DummyInvoiceController.new
      controller.index_with_default_filter
      report = controller.instance_eval { @report }
      report.records.should == [{'Title' => @inv1.title, 'Total paid' => @inv1.total_paid},
                                {'Title' => @inv2.title, 'Total paid' => @inv2.total_paid},
                                {'Title' => @inv3.title, 'Total paid' => @inv3.total_paid}]
    end

    it "should initialize with filter applied" do
      controller = DummyInvoiceController.new
      controller.params[:q] = {paid_eq: '1'}
      controller.index_with_default_filter
      report = controller.instance_eval { @report }
      report.records.should == [{'Title' => @inv2.title, 'Total paid' => @inv2.total_paid},
                                {'Title' => @inv3.title, 'Total paid' => @inv3.total_paid}]
    end
  end
end