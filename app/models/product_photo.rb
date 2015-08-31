class ProductPhoto < ActiveRecord::Base
  include Paperclip::Glue
  belongs_to :product_variant

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png",
    :storage => :s3,
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentPresenceValidator, attributes: :photo


  def s3_credentials
    {:bucket => "cholon", :access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
  end
end