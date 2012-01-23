class ConversationThreadsController < ApplicationController
  
  def new
  end
  
  def create
    conversation_id = params[:conversation_thread][:conversation_id]
    micropost_id = params[:conversation_thread][:micropost_id]
    user_id = params[:conversation_thread][:user_id]
    content = params[:conversation_thread][:content]
    
    if conversation_id == "false"
      conversation = Conversation.new(:micropost_id => micropost_id, :user_id => user_id)
      if conversation.save
        conversation_id = conversation.id
      end
    end 
    
    conversation_thread = ConversationThread.new(:conversation_id => conversation_id, :user_id => user_id, :content => content)
    
    if conversation_thread.save
      flash[:success] = "Conversation created"
      if TuringUser.find_by_id(Micropost.find_by_id(micropost_id).user.turing_user_id).name == "Twitbot"
        user_id = Micropost.find_by_id(micropost_id).user_id
        content = conversation_thread.chatbot_reply(conversation_id, content)
        conversation_thread = ConversationThread.new(:conversation_id => conversation_id, :user_id => user_id, :content => content)
        conversation_thread.save
      end
    else
      flash[:error] = "There has been a problem creating your conversation"
    end
    
    redirect_to request.referer
  end
  
end
