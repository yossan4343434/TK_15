class CreateMinisounds < ActiveRecord::Migration
  def change
    create_table :minisounds do |t|
      t.string :movie_id
      t.string :name
      t.float :playtime

      t.timestamps null: false
    end
  end
end
