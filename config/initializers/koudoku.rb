Koudoku.setup do |config|
  config.subscriptions_owned_by = :device

  if Rails.env.production?
    config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
    config.stripe_secret_key =  ENV['STRIPE_SECRET_KEY']
  else
    config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY'] || "pk_test_zFDd4y0RqTsn4NxDDi66m7iB"
    config.stripe_secret_key = ENV['STRIPE_SECRET_KEY'] || "sk_test_M5QU9zJCWB0VPmgTFhMxog5R"
  end

  Stripe.api_version = '2017-01-27' #Making sure the API version used is compatible.
  config.prorate = true
  # config.free_trial_length = 30

  # Specify layout you want to use for the subscription pages, default is application
  config.layout = false

  # you can subscribe to additional webhooks here
  # we use stripe_event under the hood and you can subscribe using the
  # stripe_event syntax on the config object:
  # config.subscribe 'charge.failed', Koudoku::ChargeFailed

end
