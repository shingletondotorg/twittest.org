require 'csv'

class CsvController < ApplicationController
  def import
  end

  def upload
    
    
    
    #table = ImportTable.new :original_path => params[:upload][:csv].original_filename
    add_user = false
    CSV.parse(params[:upload][:csv].read) do | row |
     
  
        
       
       # next if row_index == 0 or row.join.blank?
       if add_user
         logger.debug("************************************")
         logger.debug(row.inspect)
         logger.debug("************************************")
         
           u = User.new(:school_id => row[0],:email => row[1], :first_name => row[2], :last_name => row[3], :display_name => row[4], :turing_user_id => row[5], :password => row[6], :password_confirmation => row[7])
                 
           if u.valid?
              u.encrypt_password
              u.save
           end
          
        end
     
       # table.import_cells.build :column_index => column_index, :row_index => row_index, :contents => cell
      
      add_user = true
    end
    #table.save
    redirect_to users_path
  end
end
