class Invoice < ActiveRecord::Base
  attr_accessible :paid, :title, :total_charged, :total_paid
end
