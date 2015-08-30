CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],                        # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],                        # required
  }

  if Rails.env.development? || Rails.env.test?
    config.fog_directory  = "cholon-#{Rails.env}-#{ENV['DEVELOPER_NAME']}"
  elsif  Rails.env.production?
    config.fog_directory  = "cholon-#{Rails.env}"
  end                    # required
end