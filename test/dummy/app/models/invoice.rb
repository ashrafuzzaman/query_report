class Invoice < ActiveRecord::Base
  belongs_to :received_by, :class_name => "User"
  attr_accessible :invoiced_on, :paid, :paid_on, :received_by_id, :title, :total_charged, :total_paid
end
