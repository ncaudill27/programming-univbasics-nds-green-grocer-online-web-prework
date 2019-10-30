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
    couponed_name = "#{item_name} W/COUPON"
    coupon_in_cart = find_item_by_name_in_collection(coupon, cart)
    
    if coupon && item[:count] >= coupon[:num]
      if !coupon_in_cart
        couponed_item = Hash[
          :item => couponed_name,
          :price => coupon[:cost] / coupon[:num],
          :clearance => item[:clearance],
          :count => coupon[:num]
        ]
        cart << couponed_item
        item[:count] -= coupon[:num]
      else
        couponed_item[:count] += coupon[:num]
        item[:count] -= coupon[:num]
      end
    end
    
    i += 1
  end

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
	new_cart = apply_clearance(couponed_items)

	total_count = 0
	new_cart.size.times do |i|
		item = cart[i]
		total_count += item[:price] * item[:count]
	end

	if total_count >= 100
		total_count *= 0.90
	end

total_count
end
