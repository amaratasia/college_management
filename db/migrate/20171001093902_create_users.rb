class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :reg_number
      t.integer :phone
      t.integer :year_of_adm
      t.references :department, foreign_key: true

      t.timestamps
    end
  end
end
