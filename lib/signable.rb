# define signed? and signed scope on receiver
module Signable
  
  module InstanceMethods
    def signed?
      !signer_name.blank? && !signature.blank? && !signed_at.blank?
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.class_eval do
      scope :signed, where("signed_at IS NOT NULL")
    end
  end
end