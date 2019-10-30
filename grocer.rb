require 'pry'

def find_item_by_name_in_collection(name, collection)
  i = 0
  
  while i < collection.length do
    if collection[i].value?(name)
      item = collection[i]
    end
    i += 1
  end
  
item
end

def consolidate_cart(cart)
	return_cart = []
	i = 0
	
	while i < cart.length do
		item = cart[i][:item]
		item_found = find_item_by_name_in_collection(item, return_cart)
		if item_found
			item_found[:count] += 1
		else
			cart[i][:count] = 1
			return_cart << cart[i]
		end
		i += 1
	end
	
return_cart
end

def apply_coupons(cart, coupons)
  i = 0
  
  while i < cart.length do
    item = cart[i]
    item_name = cart[i][:item]
    coupon = find_item_by_name_in_collection(item_name, coupons)
    
    if coupon && item[:count] >= coupon[:num]
      if coupon
        couponed_item = Hash[
          :item => "#{item[:item]} W/COUPON",
          :price => coupon[:cost] / coupon[:num],
          :clearance => item[:clearance],
          :count => coupon[:num]
        ]
        cart << couponed_item
        item[:count] -= coupon[:num]
      elsif find_item_by_name_in_collection(couponed_item, cart)
        couponed_item[:count] += coupon[:num]
      end
    end
    
    i += 1
  end
#binding.pry
cart
end

def apply_clearance(cart)

  cart.length.times do |i|
    item = cart[i]

    if cart[i][:clearance] == true
      item[:price] *= 0.80
      item[:price] = item[:price].round(2)
    end
  end

cart
end

def checkout(cart, coupons)
	count_items = consolidate_cart(cart)
	couponed_items = apply_coupons(count_items, coupons)
	apply_clearance(couponed_items)

	total_count = 0
	cart.size.times do |i|
		item = cart[i]
		total_count += item[:price]
	end

	if total_count >= 100
		total_count *= 0.90
	end

total_count
end
