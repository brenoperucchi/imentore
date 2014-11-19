module CheckoutsHelper

  def addresses_checkout_helper
    collection = current_user.userable.addresses.collect {|x| [x.name.capitalize, x.name]}   
    collection += [[t(:other_address), 'other']]
  end

  def checkbox_shipping_helper(f)
    if f.object.shipping_checkbox == "0" 
      false
    elsif f.object.shipping_checkbox.nil? or f.object.shipping_checkbox == "1"
      true
    end
  end

end