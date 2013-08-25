require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Buffalohostage
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    AWS::S3::DEFAULT_HOST.replace "s3-us-west-2.amazonaws.com"
    if Rails.env == "production"
    AWS::S3::Base.establish_connection!(
      :s3_credentials => S3_CREDENTIALS
    )
    else 
      
    end
  end
end

