class Conversation < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost
  has_many  :conversation_threads
  
  attr_accessible :user_id, :micropost_id
  
  def last_to_reply
    tbl = self.conversation_threads.select("DISTINCT conversation_threads.user_id").order("conversation_threads.created_at DESC").limit(1)
    u = tbl.slice(0)
    u.user_id
  end   
  
end
