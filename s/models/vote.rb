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
  
  
  def update_score()
    micropost = Micropost.find_by_id(self.micropost_id)
    
    tweet_user = User.find_by_id(micropost.user_id)
    voting_user = User.find_by_id(self.user_id)
  
    if micropost.user.turing_user_id == micropost.turing_user_id
      #author is posting as themselves reward voter and author if vote matches micropost.turing_user_id
      if self.vote == micropost.turing_user_id
        voting_user.voting_real = voting_user.voting_real + 10 
        tweet_user.votes_real = tweet_user.votes_real + 10
      else
        voting_user.voting_real = voting_user.voting_real - 10
        tweet_user.votes_real = tweet_user.votes_real - 10
      end
      
    elsif
      #user is posting as a fake
      if self.vote == micropost.user.turing_user_id
        #voter spotted the fake
        voting_user.voting_fake = voting_user.voting_fake + 10
        tweet_user.votes_fake = tweet_user.votes_fake - 10
      elsif self.vote == micropost.turing_user_id
        #voter has been fooled
        voting_user.voting_fake = voting_user.voting_fake - 10
        tweet_user.votes_fake = tweet_user.votes_fake + 10
      else
        #voter partially fooled
        voting_user.voting_fake = voting_user.voting_fake + 6
        tweet_user.votes_fake = tweet_user.voting_fake + 2
      end 
    end
    
    voting_user.total_score = voting_user.votes_fake + voting_user.votes_real + voting_user.voting_fake + voting_user.voting_real
    tweet_user.total_score = tweet_user.votes_fake + tweet_user.votes_real + tweet_user.voting_fake + tweet_user.voting_real
    
    voting_user.has_voted = true
    voting_user.save!
    tweet_user.save!
   
    
  
    
    
    
  end

end
