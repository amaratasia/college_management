class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.references :exam, foreign_key: true
      t.references :subject, foreign_key: true
      t.string :mark
      t.integer :semester
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
