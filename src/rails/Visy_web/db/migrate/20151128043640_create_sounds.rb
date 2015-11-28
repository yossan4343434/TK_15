class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :name
      t.string :video_id
      t.string :playtime
      t.string :sound

      t.timestamps null: false
    end
  end
end
