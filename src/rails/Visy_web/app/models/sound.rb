class Sound < ActiveRecord::Base
mount_uploader :sound, SoundUploader
end
