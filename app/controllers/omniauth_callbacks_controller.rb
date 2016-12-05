class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      if @user.confirmed?
        flash[:notice] = "Successfully signed in."
      else
        flash[:notice] = "Please check your email to activate the account!"
      end
      sign_in(@user)
      redirect_to root_path
    else
      session["devise.user_attributes"] = @user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
