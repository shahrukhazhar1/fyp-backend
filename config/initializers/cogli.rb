def Cogli.is_device_removable?
  ENV['IS_DEVICE_REMOVABLE'] == 'true'
end

def Cogli.force_tutorial?
  ENV['FORCE_TUTORIAL'] == 'true'
end

def Cogli.fcm_api_key
  @_fcm_api_key ||= ENV['FCM_API_KEY'] || 'AAAAtZBd6QY:APA91bEvohejiI4jFTvN04vKn7c57ZG-H4pI1hVLnpshtQHYGeMFoT5cg9-4gWaFejD15aree-CyWvIMJP-9HV6ilN6Dltgs6SCR-WNLQW3eJGNAKAf1-lqG4WXyCXlM_L2wlmo1dVoy'
end

def Cogli.marketing_domain
  @_marketing_domain ||= ENV['MARKETING_DOMAIN'] || 'https://cogliapp.com'
end

def Cogli.google_play_store_url
  @_google_play_store_url ||= ENV['GOOGLE_PLAY_STORE_URL'] || 'https://play.google.com/store/apps/details?id=com.cogli.alesia'
end
