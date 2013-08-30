require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'yaml'

Bundler.require(:default, Rails.env)

module Buffalohostage
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    if Rails.env == "production"
      S3_CREDENTIALS = { :access_key_id => ENV['S3_KEY'], :secret_access_key =>
                                      ENV['S3_SECRET']}
    else
      S3_CREDENTIALS = YAML.load(File.read("config/s3.yml"))
      S3_CREDENTIALS[:access_key_id] = S3_CREDENTIALS["access_key_id"]
      S3_CREDENTIALS[:secret_access_key] = S3_CREDENTIALS["secret_access_key"]
    end
    AWS::S3::Base.establish_connection!(
      :access_key_id => S3_CREDENTIALS[:access_key_id],
      :secret_access_key => S3_CREDENTIALS[:secret_access_key]
    )
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
  end
end

