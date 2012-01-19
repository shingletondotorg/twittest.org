class CreateConversationThreads < ActiveRecord::Migration
  def self.up
    create_table :conversation_threads do |t|
      t.references :conversation
      t.references :user
      t.string :content
      t.timestamps
    end
    drop_table :threads
  end

  def self.down
    drop_table :conversation_threads
     create_table :threads do |t|
        t.references :conversation
        t.references :user
        t.string :content
        t.timestamps
      end
  end
end
