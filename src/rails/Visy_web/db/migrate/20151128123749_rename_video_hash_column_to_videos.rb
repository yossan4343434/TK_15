class RenameVideoHashColumnToVideos < ActiveRecord::Migration
  def change
     rename_column :videos, :video_hash, :youtube_id
  end
end
