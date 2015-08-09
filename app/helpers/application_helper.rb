module ApplicationHelper
	def current_locale
		I18n.locale
	end

	def current_language
		if current_locale == :en
			"English"
		else
			"Tiếng Việt"
		end
	end
end
