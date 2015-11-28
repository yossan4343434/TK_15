class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_hash
      t.string :name

      t.timestamps null: false
    end
  end
end
