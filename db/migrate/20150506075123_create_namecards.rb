class CreateNamecards < ActiveRecord::Migration
  def change
    create_table :namecards do |t|
      t.string :name
      t.string :tel
      t.string :address
      t.string :company

      t.timestamps null: false
    end
  end
end
