module CheckoutsHelper

  def addresses_checkout_helper
    collection = current_user.userable.addresses.collect {|x| [x.name.capitalize, x.name]}   
    collection += [[t(:other_address), 'other']]
  end

end