#!/usr/bin/ruby

require 'csv'

productsFile = 'resources/products.tab'
salesFile = 'resources/sales.tab'

product_category_hash = Hash.new
category_sales_hash = Hash.new
candy_sales_hash = Hash.new

# Populate the Product/Category map
CSV.foreach(File.path(productsFile), { :col_sep => "\t", :converters => :numeric}) do |col|
  product_category_hash[col[0]] = col[1]
end

CSV.foreach(File.path(salesFile), { :col_sep => "\t", :converters => :numeric}) do |col|
  product = col[0]
  sale_amount = col[1]
  # Get the category from the Product/Category hash
  category = product_category_hash[product]

  if category == nil
    category = 'UNDEFINED'
  end

  if category_sales_hash.has_key? category
    total_sale = category_sales_hash[category]
    category_sales_hash[category] = total_sale + sale_amount
  else
    category_sales_hash[category] = sale_amount
  end

  # we only want Candy products
  if category == 'Candy'
    if candy_sales_hash.has_key? product
      total_sale = candy_sales_hash[product]
      candy_sales_hash[product] = total_sale + sale_amount
    else
      candy_sales_hash[product] = sale_amount
    end
  end

end

#puts category_sales_hash
puts category_sales_hash.sort_by {|k,v| -v}.first(5).map{|k,v| puts k + ": #{v}"}
puts '*******'
puts candy_sales_hash.sort_by {|k,v| -v}.first(1).map{|k,v| puts k + ": #{v}"}