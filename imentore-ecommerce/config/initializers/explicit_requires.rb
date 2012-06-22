# http://stackoverflow.com/a/4774601
unless Rails.env.production?
  require_dependency "imentore/line_item"
  require_dependency "imentore/product"
  require_dependency "imentore/product_variant"
end
