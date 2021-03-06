FACEBOOK_CONFIG = YAML::load(File.read(Rails.root.join('config/facebook.yml')))[Rails.env]

FACEBOOK_CONFIG['app_id'] = ENV['FACEBOOK_APP_ID'] || FACEBOOK_CONFIG['app_id']
FACEBOOK_CONFIG['app_name'] = ENV['FACEBOOK_APP_NAME'] || FACEBOOK_CONFIG['app_name']
FACEBOOK_CONFIG['secret'] = ENV['FACEBOOK_SECRET'] || FACEBOOK_CONFIG['secret']
FACEBOOK_CONFIG['canvas_url'] = ENV['FACEBOOK_CANVAS_URL'] || FACEBOOK_CONFIG['canvas_url']
FACEBOOK_CONFIG['url'] = ENV['FACEBOOK_URL'] || FACEBOOK_CONFIG['url']
FACEBOOK_CONFIG['domain'] = ENV['FACEBOOK_DOMAIN'] || FACEBOOK_CONFIG['domain']

Facebooker2.app_id=FACEBOOK_CONFIG['app_id']
Facebooker2.secret=FACEBOOK_CONFIG['secret']
Facebooker2.oauth2=false

