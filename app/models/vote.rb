class Vote < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :voter, :class_name => "User", :foreign_key => 'user_id'
 
  attr_accessible :user_id, :micropost_id, :vote
  
  validates :user_id, :uniqueness => {:scope => :micropost_id}

  def self.vote_real_correct(id)
    n = Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id != ? AND votes.user_id = ?" ,id, id ).count
    return n
  end
  
  def self.vote_real_incorrect(id)
     n = Vote.joins( :micropost => :user ).where( "votes.vote != microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id != ? AND votes.user_id = ?" ,id, id ).count
    return n
  end
  
  def self.tweet_real_agreed(id)
    n = Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id ).count
    return n
  end
  
  def self.tweet_real_disagreed(id)
    n = Vote.joins( :micropost => :user ).where( "votes.vote != microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
    return n
  end
  
  def self.vote_fake_spotted(id)
     n = Vote.joins( :micropost => :user ).where( "votes.vote = users.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND votes.user_id = ? AND microposts.user_id != ?" ,id, id).count
    return n
  end
  
  def self.vote_fake_fooled(id)
   n = Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND votes.user_id = ? AND microposts.user_id != ?" ,id, id).count
  return n
  end
  
  def self.vote_fake_partial(id)
   n = Vote.joins( :micropost => :user ).where( "votes.vote != users.turing_user_id AND votes.vote != microposts.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND votes.user_id = ? AND microposts.user_id != ?" ,id, id).count
  return n
  end
  
  def self.tweet_fake_fooled(id)
    n = Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
  return n
  end
  
  def self.tweet_fake_spotted(id)
    n = Vote.joins( :micropost => :user ).where( "votes.vote = users.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
  return n
  end
  
  def self.tweet_fake_partial(id)
    n = Vote.joins( :micropost => :user ).where( "votes.vote != microposts.turing_user_id AND votes.vote != users.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
    return n
  end
  
  
  
  def self.user_scatter_vote(id)
   # scatter_points = []
   # a = [self.user_vote_correct_count(id), self.user_vote_incorrect_count(id)]  
   # scatter_points << a
   # return scatter_points
  end
  
  def self.all_users_scatter_vote(id)    
   # users = User.where("users.id != ?", id)
  
   # scatter_points = []
   # users.each do | u |
   #   a = [self.user_vote_correct_count(u.id), self.user_vote_incorrect_count(u.id)]
   #   scatter_points << a
   # end
   # return scatter_points
  end
  
  
  

end
