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
  end

  def render_report #override the existing renderer
  end

  def index
    @invoices = DummyInvoice.scoped

    reporter(@invoices) do
      filter :title, type: :text
      filter :created_at, type: :date

      column :title do |invoice|
        #link_to invoice.title, invoice
        invoice.title
      end
      column :total_paid
      column :total_charged
      column :paid

      column_chart('Unpaid VS Paid') do
        add 'Unpaid' do |query|
          query.sum('total_charged').to_f - query.sum('total_paid').to_f
        end
        add 'Paid' do |query|
          query.sum('total_paid').to_f
        end
      end
    end
  end
end

describe DummyInvoiceController do
  context "when included by a controller" do
    it "works" do
      DummyInvoice.create(title: 'Invoice#1', total_charged: 100, total_paid: 100, paid: true)
      DummyInvoice.create(title: 'Invoice#2', total_charged: 200, total_paid: 100, paid: false)

      controller = DummyInvoiceController.new
      controller.index
      report = controller.instance_eval { @report }
      ap report.records
    end
  end

  #reporter(query, 'ajax_report') do
  #  filter :name
  #
  #  column :name
  #  column :age
  #  column :weight
  #end
end