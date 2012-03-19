class LogReportingUsers < ActiveRecord::Migration
  def self.up
    add_column :microposts, :penalised_by, :integer
    add_column :microposts, :reported_by, :integer
  end

  def self.down
    remove_column :microposts, :penalised_by
    remove_column :microposts, :reported_by
  end
end
