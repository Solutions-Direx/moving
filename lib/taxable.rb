module Taxable
  module ClassMethods
    
  end
  
  module InstanceMethods
    def tax1_name(show_percentage = true)
      if tax1_label.blank?
        show_percentage ? "Tax 1 (#{tax1}%)" : "Tax 1"
      else
        show_percentage ? "#{tax1_label} (#{tax1}%)" : tax1_label
      end
    end

    def tax2_name(show_percentage = true)
      if tax2_label.blank?
        show_percentage ? "Tax 2 (#{tax2}%)" : "Tax 2"
      else
        show_percentage ? "#{tax2_label} (#{tax2}%)" : tax2_label
      end
    end
    
    def any_taxes?
      !(tax1.blank? && tax2.blank?)
    end
    
    def tax_options
      taxes = [["No tax", 0]]
      taxes << [tax1_name, 1] unless tax1.blank?
      taxes << [tax2_name, 2] unless tax2.blank?
      taxes << ["Both", 3] unless tax1.blank? || tax2.blank?
      taxes
    end
    
    def copy_tax_setting_to(target)
      self.tax1       = target.tax1
      self.tax1_label = target.tax1_label
      self.tax2       = target.tax2
      self.tax2_label = target.tax2_label
      self.compound   = target.compound
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end