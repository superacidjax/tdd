class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :comapny_name, :email
  
  has_many :notes
end