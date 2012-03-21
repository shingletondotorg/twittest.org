class AddUserTweeted < ActiveRecord::Migration
  
  def self.up
    add_column :users, :has_tweeted, :boolean, :default => false
  end

  def self.down
    remove_column :users, :has_tweeted
  end
  
end
