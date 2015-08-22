# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = ["Baby & Kids", "Baby & Kids Sub","Bath & Body", "Beauty", "Business For Sale",
              "Classified Ads", "Car Electronics & GPS", "Cars & Trucks & Motocycles",
              "Cameras & Camcorders", "Computer Parts & Components", "Commercials Appliances",
              "Coupon & Deals", "Desktops & Monitors", "Digital Electronics",
              "Electronics & Computers", "Electronics Accessories", "Fashions & Beauty",
              "Home Appliances", "Home Audios & Theaters", "House For Sale", "House For Rent",
              "Jobs", "Kitchen Appliances", "Laptops & Tablets", "Laptops & Tablets & Desktops",
              "Looking To Hire", "Looking For Job", "Lifestyle & Health", "Make Up",
              "Mens Fashions", "Men Shirts & Pants", "Men Shoes", "Men Accessories",
              "Other Electronics", "Office Machines", "Office Attire & Occasional Wear",
              "Others Machines", "Outerwear", "Room For Rent/Share", "Skin Care", "Shirts & Pants",
              "Services", "Services Ads", "TVs & Videos", "Trade", "Tools & Accessories",
              "Video Games & Softwares & DVDs", "Womens Fashions", "Women Shoes", "Women Accessories"
              ]

categories.each do |cat|
  Category.find_or_create_by(name: cat)
end

# NOTE : write a cat mapper for parent cat