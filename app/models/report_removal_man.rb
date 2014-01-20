class ReportRemovalMan < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :report
  belongs_to :removal_man, class_name: "User", foreign_key: "removal_man_id"


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :removal_man_id, :report_id

end
