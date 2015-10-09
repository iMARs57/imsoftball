class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :member_id
      t.integer :number
      t.string :name
      t.date :birthday
      t.string :birthplaceCH
      t.string :birthplaceEN
      t.string :high_schoolCH
      t.string :high_schoolEN
      t.string :position
      t.string :bats
      t.string :throws

      t.timestamps null: false
    end
  end
end
