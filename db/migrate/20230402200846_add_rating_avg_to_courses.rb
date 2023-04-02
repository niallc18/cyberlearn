class AddRatingAvgToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :rating_avg, :float, default: 0.0, null:false
  end
end
