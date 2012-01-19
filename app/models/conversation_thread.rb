class ConversationThread < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  attr_accessible :conversation_id, :user_id, :content
end
