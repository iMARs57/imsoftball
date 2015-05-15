class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.date :date
      t.text :description
      t.boolean :is_public

      t.timestamps null: false
    end
  end
end
