class RenameMovieIdColumnToMinisounds < ActiveRecord::Migration
  def change
   rename_column :minisounds, :movie_id, :video_id
  end
end
