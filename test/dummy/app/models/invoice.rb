class Invoice < ActiveRecord::Base
  attr_accessible :invoiced_on, :paid, :paid_on, :received_by, :title, :total_charged, :total_paid
end