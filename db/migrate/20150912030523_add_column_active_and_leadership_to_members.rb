class AddColumnActiveAndLeadershipToMembers < ActiveRecord::Migration
  def change
	add_column :members, :active, :boolean
	add_column :members, :leadership, :integer
  end
end
