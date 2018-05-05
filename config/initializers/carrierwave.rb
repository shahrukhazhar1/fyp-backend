CarrierWave.configure do |config|
  config.storage                             = :gcloud
  config.gcloud_bucket                       = 'cogli-remote-assets-4'
  config.gcloud_bucket_is_public             = true
  config.gcloud_authenticated_url_expiration = 600

  config.gcloud_attributes = {
    expires: 600
  }

  config.gcloud_credentials = {
    gcloud_project: ENV['GCLOUD_PROJECT'] || 'level-amphora-174304',
    gcloud_keyfile: ENV['GCLOUD_KEYFILE'] || 'gcloud-service-key.json'
  }
end
