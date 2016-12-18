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
              "Video Games & Softwares & DVDs", "Womens Fashions", "Women Shoes", "Women Accessories",
              "Eyeliner"]

categories.each do |cat|
  Category.find_or_create_by(name: cat)
end

# Catergory parent_id mapper start
  #1
lap_tab_desk = ["Laptops & Tablets", "Desktops & Monitors", "Office Machines",
                "Computer Parts & Components", "Electronics Accessories",
                "Video Games & Softwares & DVDs"]
ltd_parent = Category.find_by_name("Laptops & Tablets & Desktops")

Category.where(:name => lap_tab_desk).update_all(:parent_id => ltd_parent)

  #2
dig_elc = ["TVs & Videos", "Home Audios & Theaters", "Cameras & Camcorders",
          "Car Electronics & GPS"]
dig_elc_parent = Category.find_by_name("Digital Electronics")

Category.where(:name => dig_elc).update_all(:parent_id => dig_elc_parent)

  #3
other_elc = ["Home Appliances", "Kitchen Appliances", "Commercials Appliances",
              "Others Machines"] 
other_elc_parent = Category.find_by_name("Other Electronics")

Category.where(:name => other_elc).update_all(:parent_id => other_elc_parent)

  #4

beauty = ["Make Up", "Skin Care", "Bath & Body", "Lifestyle & Health",
        "Tools & Accessories"]
beauty_parent = Category.find_by_name("Beauty")

Category.where(:name => beauty).update_all(:parent_id => beauty_parent)

make_up = ["Eyeliner"]

make_up_parent = Category.find_by_name("Make up")
Category.where(:name => make_up).update_all(:parent_id => make_up_parent)



  #5
women_fashion = ["Office Attire & Occasional Wear", "Outerwear", "Shirts & Pants",
                "Women Shoes", "Women Accessories"]
women_fashion_parent = Category.find_by_name("Womens Fashions")

Category.where(:name => women_fashion).update_all(:parent_id => women_fashion_parent)

  # 6
men_fashion = ["Men Shirts & Pants", "Men Shoes", "Men Accessories"]
men_fashion_parent = Category.find_by_name("Mens Fashions")

Category.where(:name => men_fashion).update_all(:parent_id => men_fashion_parent)

  #7
baby = ["Baby & Kids Sub"]
baby_parent = Category.find_by_name("Baby & Kids")

Category.where(:name => baby).update_all(:parent_id => baby_parent)

  #8
trade = ["House For Sale", "House For Rent", "Room For Rent/Share",
          "Business For Sale", "Cars & Trucks & Motocycles"]

trade_parent = Category.find_by_name("Trade")

Category.where(:name => trade).update_all(:parent_id => trade_parent)

  #9
jobs = ["Looking To Hire", "Looking For Job"]
jobs_parent = Category.find_by_name("Jobs")

Category.where(:name => jobs).update_all(:parent_id => jobs_parent)

  #10
service = ["Services Ads"]
service_parent = Category.find_by_name("Services")

Category.where(:name => service).update_all(:parent_id => service_parent)



#State

state_list = {'AL'=>'Alabama',
    'AK'=>'Alaska',
    'AZ'=>'Arizona',
    'AR'=>'Arkansas',
    'CA'=>'California',
    'CO'=>'Colorado',
    'CT'=>'Connecticut',
    'DE'=>'Delaware',
    'DC'=>'District of Columbia',
    'FL'=>'Florida',
    'GA'=>'Georgia',
    'HI'=>'Hawaii',
    'ID'=>'Idaho',
    'IL'=>'Illinois',
    'IN'=>'Indiana',
    'IA'=>'Iowa',
    'KS'=>'Kansas',
    'KY'=>'Kentucky',
    'LA'=>'Louisiana',
    'ME'=>'Maine',
    'MD'=>'Maryland',
    'MA'=>'Massachusetts',
    'MI'=>'Michigan',
    'MN'=>'Minnesota',
    'MS'=>'Mississippi',
    'MO'=>'Missouri',
    'MT'=>'Montana',
    'NE'=>'Nebraska',
    'NV'=>'Nevada',
    'NH'=>'New Hampshire',
    'NJ'=>'New Jersey',
    'NM'=>'New Mexico',
    'NY'=>'New York',
    'NC'=>'North Carolina',
    'ND'=>'North Dakota',
    'OH'=>'Ohio',
    'OK'=>'Oklahoma',
    'OR'=>'Oregon',
    'PA'=>'Pennsylvania',
    'RI'=>'Rhode Island',
    'SC'=>'South Carolina',
    'SD'=>'South Dakota',
    'TN'=>'Tennessee',
    'TX'=>'Texas',
    'UT'=>'Utah',
    'VT'=>'Vermont',
    'VA'=>'Virginia',
    'WA'=>'Washington',
    'WV'=>'West Virginia',
    'WI'=>'Wisconsin',
    'WY'=>'Wyoming'
  }

state_list.each do |k, v|
  State.find_or_create_by(name: v, abbreviation: k)
end











  











