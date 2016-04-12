class Cpanels::HomeController < CpanelController
  before_action :authenticate_user!

  def index
    @statistic = Order.join_all.statistic
      .with_sellers([current_user.id])
  end
end
