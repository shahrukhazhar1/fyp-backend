Airbrake.configure do |config|
  config.api_key = ENV['ERRBIT_API_KEY'] || '6e06448e76062c1ab2ab1b896c002fd3'
  config.host    = 'errbit.cogliapp.com'
  config.port    = 80
  config.secure  = config.port == 443
  config.development_environments = []
end
