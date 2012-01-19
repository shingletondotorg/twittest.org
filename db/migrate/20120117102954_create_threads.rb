class CreateThreads < ActiveRecord::Migration
  def self.up
    create_table :threads do |t|
      t.references :conversation
      t.references :user
      t.string :content
      t.timestamps
    end
  end

  def self.down
    drop_table :threads
  end
end
