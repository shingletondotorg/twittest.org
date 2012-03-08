class AddScoresToUserModel < ActiveRecord::Migration

  def self.up
    add_column :users, :has_voted, :boolean, :default => false
    add_column :users, :total_score, :integer, :default => 0 
    add_column :users, :votes_real, :integer, :default => 0 
    add_column :users, :votes_fake, :integer, :default => 0 
    add_column :users, :voting_real, :integer, :default => 0 
    add_column :users, :voting_fake, :integer, :default => 0 
  end

  def self.down
    remove_column :users, :has_voted
    remove_column :users, :total_score
    remove_column :users, :votes_real 
    remove_column :users, :votes_fake 
    remove_column :users, :voting_real 
    remove_column :users, :voting_fake
  end
  
end
