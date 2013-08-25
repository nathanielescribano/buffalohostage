require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Buffalohostage
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    AWS::S3::DEFAULT_HOST.replace "s3-us-west-2.amazonaws.com"
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'private', 
      :secret_access_key => 'private'
    )
  
  end
end

