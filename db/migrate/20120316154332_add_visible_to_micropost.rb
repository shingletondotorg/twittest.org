class AddVisibleToMicropost < ActiveRecord::Migration
  def self.up
      add_column :microposts, :is_visible, :boolean, :default => false
      add_column :microposts, :report_user, :boolean, :default => false
  end

  def self.down
      remove_column :microposts, :is_visible
      remove_column :microposts, :report_user
  end
end
