Fabricator(:order) do
  shipping_address Imentore::Address.last
  billing_address Imentore::Address.last
  status "pending"
  customer_email { Faker::Mail}
end
