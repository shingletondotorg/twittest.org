class CreateVotes < ActiveRecord::Migration
    def self.up
      create_table :votes do |t|
       t.references :user
       t.references :micropost
       t.integer :vote
       t.timestamps
      end
       add_index :votes, :user_id
       add_index :votes, :micropost_id
    end

    def self.down
      drop_table :votes
    end
  end
