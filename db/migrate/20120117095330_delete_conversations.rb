class DeleteConversations < ActiveRecord::Migration
  def self.up
    remove_column :conversations, :content
  end

  def self.down
    add_column :conversations, :content, :string
  end
end
