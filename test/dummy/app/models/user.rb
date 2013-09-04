class User < ActiveRecord::Base
  has_many :invoices, :foreign_key => "received_by_id"
  attr_accessible :email, :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end
end
