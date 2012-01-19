class ConversationThreadsController < ApplicationController
  
  def new
  end
  
  def create
    conversation_id = params[:conversation_thread][:conversation_id]
    micropost_id = params[:conversation_thread][:micropost_id]
    user_id = params[:conversation_thread][:user_id]
    content = params[:conversation_thread][:content]
    
    logger.debug "conversation attributes hash: #{conversation_id}"

    
    if conversation_id == "false"
      conversation = Conversation.new(:micropost_id => micropost_id, :user_id => user_id)
      if conversation.save
       # conversation_id = Conversation.where("micropost_id = ? AND user_id = ?", micropost_id, user_id)
       conversation_id = conversation.id
      end
    end 
    
     conversation_thread = ConversationThread.new(:conversation_id => conversation_id, :user_id => user_id, :content => content)
      if conversation_thread.save
        flash[:success] = "Conversation created"
      
      else
        flash[:error] = "There has been a problem creating your conversation"
      end

    
    
    redirect_to voteontweets_path
  end
  
end
