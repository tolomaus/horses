FACEBOOK_CONFIG = YAML::load(File.read(Rails.root.join('config/facebook.yml')))[Rails.env]

FACEBOOK_CONFIG['app_id'] = ENV['FACEBOOK_APP_ID'] || FACEBOOK_CONFIG['app_id']
FACEBOOK_CONFIG['secret'] = ENV['FACEBOOK_SECRET'] || FACEBOOK_CONFIG['secret']
FACEBOOK_CONFIG['url'] = ENV['FACEBOOK_URL'] || FACEBOOK_CONFIG['url']