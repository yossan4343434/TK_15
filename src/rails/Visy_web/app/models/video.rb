class Video < ActiveRecord::Base
 has_many :sounds
 has_many :minisounds
end
