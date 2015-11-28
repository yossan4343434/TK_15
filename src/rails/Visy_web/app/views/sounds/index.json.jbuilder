json.array!(@sounds) do |sound|
  json.extract! sound, :id, :name, :video_id, :playtime, :sound
  json.url sound_url(sound, format: :json)
end
