if @quiz_result.errors.any?
  json.errors @quiz_result.errors
else
  json.(@quiz_result, :id, :correct, :wrong, :created_at)
end
