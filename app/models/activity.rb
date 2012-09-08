class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => "User", :foreign_key => "actor_id"  
  belongs_to :quote
  belongs_to :trackable, :polymorphic => true
  attr_accessible :actor_id, :quote_id, :trackable_id, :trackable_type, :action

  default_scope order('created_at DESC')
  scope :recent, lambda {|num| where("created_at > ?", num.days.ago)}
  scope :period, lambda {|start_num, end_num| where("created_at < ? AND created_at > ?", start_num == 0 ? Time.now : start_num.days.ago , end_num.days.ago)}
end