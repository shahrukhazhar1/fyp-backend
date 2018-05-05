json.devices do
  json.array! @devices do |device|
    json.id         device.id
    json.name       device.name
    json.device_id  device.device_id
    json.created_at device.created_at
    json.fcm_token  device.fcm_token.to_s
  end
end
