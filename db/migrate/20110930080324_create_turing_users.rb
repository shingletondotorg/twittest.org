class CreateTuringUsers < ActiveRecord::Migration
  def self.up
    create_table :turing_users do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :turing_users
  end
end
