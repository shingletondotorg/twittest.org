class MicropostsAddTuringUser < ActiveRecord::Migration
  def self.up
    change_table :microposts do |t|
       t.references :turing_user
      end
    
  end

  def self.down
    remove_column :microposts, :turing_user_id
  end
end
