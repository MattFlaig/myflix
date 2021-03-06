Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = true
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'http://quiet-chamber-2363-staging.herokuapp.com/' }
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :port           => ENV['MAILGUN_SMTP_PORT'],
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         =>  'http://quiet-chamber-2363-staging.herokuapp.com/',
    :authentication => :plain,
  }


end
