class ChangeDatatypeMovieIdOfMinisounds < ActiveRecord::Migration
  def change
    change_column :minisounds, :movie_id, :integer
  end
end
