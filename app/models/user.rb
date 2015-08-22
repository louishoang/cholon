class User < ActiveRecord::Base
  has_many :products


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  #find or create new account from omniauth response
  def self.from_omniauth(auth_hash)
    User.find_or_create_by(uid: auth_hash[:uid], provider: auth_hash[:provider]) do |user|
      user.email = auth_hash[:info][:email]
      user.avatar_url = auth_hash[:info][:image]
      user.first_name = auth_hash[:info][:first_name]
      user.last_name = auth_hash[:info][:last_name]
    end
  end

  # if omniauth fails to create user on first try,
   # it will be saved in session,
    # then re-use those info to create user
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user_attributes = params
        user.valid?
      end
    else
      super
    end
  end

  #override login ask for password when using omniauth
  def password_required?
    super && provider.blank?
  end

  #override update information with password for omniauth
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end