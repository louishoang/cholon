class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper ApplicationHelper

  #Set up multi-locale filter
  before_action :set_locale
  def set_locale
  	I18n.locale = params[:locale] || I18n.default_locale
  end

  # Get locale code from request subdomain (like http://vi.application.local:3000)
	# You have to put something like:
	#   127.0.0.1 vi.application.local
	# in your /etc/hosts file to try this out locally
	def extract_locale_from_subdomain
	  parsed_locale = request.subdomains.first
	  I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
	end

	#merge locale to url_for
	def default_url_options(options = {})
	  { locale: I18n.locale }.merge options
	end

  def current_per_page
    params[:per_page].to_i || 48
  end
end
