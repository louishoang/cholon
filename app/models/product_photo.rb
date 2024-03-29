class ProductPhoto < ActiveRecord::Base
  include Paperclip::Glue
  belongs_to :product_variant
  #NOTE: do not validate product_variant_id

  has_attached_file :photo,
    styles: { medium: "235x216#", thumb: "125x71#", detail: "730x411#",
              s_rectangle: "365x205#", featured: "492x295#",
              featured_small: "154x92#"},
    convert_options: {
      detail: " -gravity center -crop '730x410+0+0'",
      s_rectangle: " -gravity center -crop '365x205+0+0'",
      medium: " -gravity center -crop '235x216+0+0'",
      thumb: " -gravity center -crop '125x71+0+0'",
      featured: " -gravity center -crop '492x295+0+0'",
      featured_small: " -gravity center -crop '154x92+0+0'"
    },
    default_url: "/images/:style/missing.png",
    :storage => :s3,
    :s3_host_name => 's3-us-west-2.amazonaws.com',
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentPresenceValidator, attributes: :photo


  def s3_credentials
    {:bucket => ENV['S3_BUCKET_NAME'], :access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
  end
end