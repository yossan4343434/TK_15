class ChangeDatatypePlaytimeOfSounds < ActiveRecord::Migration
  def change
    change_column :sounds, :playtime, :float
  end
end
