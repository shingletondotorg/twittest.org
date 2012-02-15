class School < ActiveRecord::Base
  has_many :users
  validates :name, :presence => true,
                   :length   => { :maximum => 150 },
                   :uniqueness => { :case_sensitive => false }
                   
  
  
  def self.leaderboard
    School.where(:visible => true).sort_by {|school| - school.score}
  end
  
  def position_overall
    n = School.leaderboard.index(self) + 1
    return n.ordinalize
  end
  
  # ----------------------------------------------------------------------------------------------
  # users in school leaderboards
 
  def users_leaderboard
    self.users.sort_by {|user| - user.score}
  end
  
  def users_leaderboard_votes_real
    self.users.sort_by {|user| - user.score_my_vote_real}
  end
  
  def users_leaderboard_votes_fake
    self.users.sort_by {|user| - user.score_my_vote_fake}
  end
  
  def users_leaderboard_voting_real
     self.users.sort_by {|user| - user.score_voting_my_real}
  end

  def users_leaderboard_voting_fake
    self.users.sort_by {|user| - user.score_voting_my_fake}
  end
  
  # ----------------------------------------------------------------------------------------------
  
  
  def score
    n = self.users.map{|user| user.score}.sum
    return n
  end
  
  def self.leaderboard_summary(id)
   n = School.where(:visible => true).count
   if n <= 5
      return School.leaderboard
   else
       p = School.leaderboard.index(id)
       case p
       when  0
         return School.leaderboard.slice(0..4)
       when 1
         return School.leaderboard.slice(0..4)
       else
         if p == n-1
             s = p-4
             e = n    
         elsif p == n-2
             s = p-3
             e = n
         else
           s = p - 2
           e = p + 2
         end
         return School.leaderboard.slice(s..e)
       end
   end  
  
  end
  
end
