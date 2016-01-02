module OrdersHelper
  def select_state(name, selected=nil, options={})
    states = []
    State.all.each{|p| states << [p.name, p.name]}
    select_tag(name, options_for_select(states, selected), options)
  end

  def select_month(name, selected=nil, options={})
    months = []
    (1..12).each{|month| months << [sprintf('%02d', month), sprintf('%02d', month)]}
    select_tag(name, options_for_select(months, selected), options)
  end

  def select_year(name, selected=nil, options={})
    years = []
    this_year = Time.now.strftime("%Y")
    fifteen_year_later = (this_year.to_i + 15).to_s
    (this_year..fifteen_year_later).each{|year| years << [sprintf('%02d', year), sprintf('%02d', year)]}
    select_tag(name, options_for_select(years, selected), options)
  end
end
