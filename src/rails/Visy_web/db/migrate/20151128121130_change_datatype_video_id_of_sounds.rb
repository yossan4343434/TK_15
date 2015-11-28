class ChangeDatatypeVideoIdOfSounds < ActiveRecord::Migration
  def change
    change_column :sounds, :video_id, :integer
  end
end
