class UsersAddToSchool < ActiveRecord::Migration
  def self.up
     change_table :users do |t|
         t.references :school
      end
  end

  def self.down 
    remove_column :users, :school_id
  end
  
end
