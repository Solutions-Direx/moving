class Document < ActiveRecord::Base
  belongs_to :account
  attr_accessible :body, :name
  validates :account_id, :body, :name, :presence => true
  validates :name, :uniqueness => true
end
