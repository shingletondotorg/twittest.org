class SchoolVisible < ActiveRecord::Migration
  def self.up
    add_column :schools, :visible, :boolean
  end

  def self.down
    remove_column :schools, :visible
  end
end
