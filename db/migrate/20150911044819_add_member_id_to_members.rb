class AddMemberIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :member_id, :string
  end
end
