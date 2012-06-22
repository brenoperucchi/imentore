module ProductHelper
  def brand_collection(current_store)
    current_store.product_brands.map{|s| s.name.nil? ? '' : s.name}
  end
end