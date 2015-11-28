json.array!(@minisounds) do |minisound|
  json.extract! minisound, :id, :video_id, :name, :playtime
  json.url minisound_url(minisound, format: :json)
end
