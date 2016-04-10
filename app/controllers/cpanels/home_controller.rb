class Cpanels::HomeController < CpanelController
  before_action :authenticate_user!

  def index
  end
end
