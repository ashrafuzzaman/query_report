class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :title
      t.float :total_paid
      t.float :total_charged
      t.boolean :paid
      t.string :received_by
      t.date :invoiced_on
      t.date :paid_on

      t.timestamps
    end
  end
end
