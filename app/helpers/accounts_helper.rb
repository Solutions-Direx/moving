module AccountsHelper
  
  #def get_account_address(account)
   # safe_concat(account.address + tag(:br) + account.city + ", " + account.province + ", " + account.postal_code)
    
  #end
  
  # def get_account_address(account, wrapper_tag = :address)
  #     content_tag(wrapper_tag) do
  #       safe_concat(account.address + tag(:br) + 
  #                   account.city + ", " + account.province + ", " + account.postal_code)
  #     end
  #   end
  
  def get_account_address account
    html = ""
    #html << "<strong>#{p.company}</strong><br />" unless p.company.blank?
    html << account.address << "<br />" unless account.address.blank?
    #html << p.address2 << "<br />" unless p.address2.blank?
    #html << p.city << ", " unless p.city.blank?
    #html << p.province << " " unless p.province.blank?
    #html << p.postal_code unless p.postal_code.blank?
    #html << "<br />" unless p.city.blank? && p.province.blank? && p.postal_code.blank?
    #html << p.country << "<br />" unless p.country.blank?
    #html << p.phone_number << "<br />" unless p.phone_number.blank?
    html.html_safe
  end
end