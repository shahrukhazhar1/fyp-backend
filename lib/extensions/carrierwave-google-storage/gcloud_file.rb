module CarrierWave
  module Storage
    class GcloudFile
      alias_method :old_store, :store

      def store(new_file)
        ct = MIME::Types.type_for(new_file.path).first.content_type
        new_file.content_type = ct

        new_file_path = uploader.filename ?  uploader.filename : new_file.filename
        bucket.create_file new_file.path, path, content_type: new_file.content_type
        self
      end
    end
  end
end
