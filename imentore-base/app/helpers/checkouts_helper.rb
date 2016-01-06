module CheckoutsHelper

  def addresses_checkout_helper
    collection = current_user.userable.addresses.collect {|x| [x.name.capitalize, x.name]}   
    collection += [[t(:other_address), 'other']]
  end

  def checkbox_shipping_helper(f, attr = :shipping_checkbox)
    if f.object.send(attr) == "0" or f.object.send(attr).nil?
      false
    elsif f.object.send(attr) == "1"
      true
    end
  end

end