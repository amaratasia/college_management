class AddDateOfExamToScores < ActiveRecord::Migration[5.1]
  def change
    add_column :scores, :date_of_exam, :datetime
  end
end
