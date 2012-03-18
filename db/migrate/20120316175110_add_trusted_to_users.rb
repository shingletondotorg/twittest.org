class AddTrustedToUsers < ActiveRecord::Migration
  
  def self.up
    add_column :users, :is_trusted, :boolean, :default => false
    add_column :users, :n_reported, :integer, :default => 0
    add_column :users, :n_approved, :integer, :default => 0
  end

  def self.down
    remove_column :users, :is_trusted
    remove_column :users, :n_reported
    remove_column :users, :n_approved
  end
  
end
