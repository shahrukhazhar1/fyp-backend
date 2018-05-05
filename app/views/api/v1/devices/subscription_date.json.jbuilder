json.device do |json|
  json.id               @device.id
  json.name             @device.name
  json.device_id        @device.device_id
  json.subscription_start_date  @device.subscription_start_date
  json.subscription_end_date  @device.subscription_end_date
  json.fcm_token  @device.fcm_token.to_s

end