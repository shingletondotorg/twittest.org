class AmendUserTable < ActiveRecord::Migration
  def self.up
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
    add_column :users, :display_name, :string
  
  end

  def self.down
    rename_column :users, :first_name, :name
    remove_column :users, :last_name
    remove_column :users, :display_name
  end
end
