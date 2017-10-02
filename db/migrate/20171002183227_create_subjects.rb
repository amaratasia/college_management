class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :subject_code
      t.references :department, foreign_key: true
      t.integer :weightage

      t.timestamps
    end
  end
end
