class AddTypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :turing_user_id, :integer
  end

  def self.down
    remove_column :users, :turing_user_id
  end
end
