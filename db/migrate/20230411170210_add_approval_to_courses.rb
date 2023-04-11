class AddApprovalToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :approval, :boolean, default: false
  end
end
