class Micropost < ActiveRecord::Base
  attr_accessible :content, :turing_user_id
  profanity_filter :content
 
  belongs_to :user
  belongs_to :turing_user
  has_many :votes
  has_many :voters, :through => :votes
  
  has_many :conversations

  validates :content, :length => { :maximum => 140 },
                      :presence => true
  validates :user_id, :presence => true
  validates :turing_user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC'
  scope :display, joins(:turing_user)
  
   

  
  scope :timeline, lambda { | opts | 
    where( "microposts.user_id != ?", opts[:id] ) 
  }

  scope :not_voted, lambda { | opts | 
    joins("LEFT JOIN votes ON votes.micropost_id = microposts.id AND votes.user_id = #{opts[:id]}").where("votes.id IS NULL AND microposts.user_id != #{opts[:id]}")
  }
  
  scope :all_tweets, lambda { | opts | 
     
   }
  
  scope :not_voted_no_conversation, lambda { | opts | 
    joins("LEFT JOIN votes ON votes.micropost_id = microposts.id AND votes.user_id = #{opts[:id]} LEFT JOIN conversations ON conversations.micropost_id = microposts.id AND conversations.user_id = #{opts[:id]}").where("votes.id IS NULL AND microposts.user_id != #{opts[:id]} AND conversations.id IS NULL")
  }
  

  
  def has_votes?
    self.votes.count != 0
  end
  
  def ive_voted?(id)
    self.votes.where("votes.user_id = ?", id).count != 0
  end
  
  def in_conversation?(id)
     rs = self.conversations.select("DISTINCT conversations.id").where("conversations.user_id = ?", id)
     if rs.count > 0 then 
       r = rs.slice(0)
       r.id
     else
       return false
     end
  end
  
  
  
  
  def last_to_reply(user_id, conversation_id)
  
    
    tbl = Conversation.find_by_id(conversation_id).conversation_threads.select("DISTINCT conversation_threads.user_id").where("conversation_threads.user_id = ? OR conversation_threads.user_id = ?", user_id, self.user_id).order("conversation_threads.created_at DESC").limit(1)
    if tbl.count > 0 then 
      u = tbl.slice(0)
      u.user_id
    else
      return false
    end 
 
  end
  
  def tweet_replies(user_id, conversation_id)
    Conversation.find_by_id(conversation_id).conversation_threads
  end
  
end

# == Schema Information
#
# Table name: microposts
#
#  id             :integer         primary key
#  content        :string(255)
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  turing_user_id :integer
#

