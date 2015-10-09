class AddColumnImAge < ActiveRecord::Migration
  def change
	 add_column :members, :IM_age, :integer
  end
end
