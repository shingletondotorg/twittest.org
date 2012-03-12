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
    self.users.order("users.total_score DESC").where("users.has_voted" => true)
  end
  
  def users_leaderboard_votes_real
     self.users.order("users.votes_real DESC").where("users.has_voted" => true)
  end
  
  def users_leaderboard_votes_fake
     self.users.order("users.votes_fake DESC").where("users.has_voted" => true)
  end
  
  def users_leaderboard_voting_real
      self.users.order("users.voting_real DESC").where("users.has_voted" => true)
  end

  def users_leaderboard_voting_fake
    self.users.order("users.voting_fake DESC").where("users.has_voted" => true)
  end
  
  # ----------------------------------------------------------------------------------------------
  
  
  def score
    self.users.where("users.has_voted" => true).sum("users.total_score")
  end





   def self.leaderboard_summary(id)
   n = School.where(:visible => true).count
     if n <= 5
       return School.leaderboard
     else
        p = School.leaderboard.index(School.find_by_id(id))

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
