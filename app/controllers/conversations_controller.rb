class ConversationsController < ApplicationController
  
  def new
   
  end

  def index
   
  end

  def show
    
  end

  def create
    @conversation = Conversation.new(params[:conversation])
    if @conversation.save
      flash[:success] = "Conversation saved"
      redirect_to root_path
    else
      # Reset password to it's cleared in the form input
      flash.now[:error] = "There has been a problem saving your conversation"
      redirect_to root_path
    end
  end

 

  def edit
   
  end

  def update
  
  end
  
  

  def destroy
   
  end

  
end
