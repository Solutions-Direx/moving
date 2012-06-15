class ReportRemovalMan < ActiveRecord::Base
  belongs_to :report
  belongs_to :removal_man, :class_name => "User", :foreign_key => "removal_man_id"
  attr_accessible :removal_man_id, :report_id
end
