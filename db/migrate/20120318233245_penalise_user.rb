class PenaliseUser < ActiveRecord::Migration
  def self.up
    add_column :microposts, :penalise_user, :boolean, :default => false
    add_column :users, :n_penalised, :integer, :default => 0
  end

  def self.down
    remove_column :microposts, :penalise_user
    remove_column :users, :n_penalised
  end
end
