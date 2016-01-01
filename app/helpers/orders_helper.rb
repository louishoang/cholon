module OrdersHelper
  def select_state(name, selected=nil, options={})
    states = []
    State.all.each{|p| states << [p.name, p.name]}
    select_tag(name, options_for_select(states, selected), options)
  end
end
