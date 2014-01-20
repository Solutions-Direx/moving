class QuoteRemovalMan < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :removal_man, class_name: "User", foreign_key: "removal_man_id"
  attr_accessible :quote_id, :removal_man_id


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def full_name
    "#{first_name} #{last_name}"
  end

end