class Sound < ActiveRecord::Base
mount_uploader :sound, SoundUploader
belongs_to :video
end
