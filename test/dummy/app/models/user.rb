class User < ActiveRecord::Base
  attr_accessible :dob, :email, :name, :single
end
