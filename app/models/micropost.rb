class Micropost < ActiveRecord::Base
  attr_accessible :content, :turing_user_id
  profanity_filter :content
 
  belongs_to :user
  belongs_to :turing_user
  has_many :votes
  has_many :voters, :through => :votes

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
  
  def has_votes?
    self.votes.count != 0
  end
  
  def ive_voted?(id)
    self.votes.where("votes.user_id = ?", id).count != 0
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

