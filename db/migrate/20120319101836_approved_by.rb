class ApprovedBy < ActiveRecord::Migration
  def self.up
     add_column :microposts, :approved_by, :integer
  end

  def self.down
    remove_column :microposts, :approved_by
  end
end
