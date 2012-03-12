require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password # creates virtual "password" attribute
  attr_accessible :first_name, :last_name, :display_name, :email, :password, :password_confirmation, :turing_user_id, :school_id, :voting_fake ,:voting_real, :votes_fake, :votes_real, :has_voted
  has_many :microposts, :dependent => :destroy
  has_many :votes
  belongs_to :school

  has_many :conversations, :through => :microposts


  # http://railstutorial.org/chapters/modeling-and-viewing-users-one#code:validates_format_of_email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :school_id, :presence => true
  validates :turing_user_id, :presence => true
  
  validates :first_name, :presence => true,
                   :length   => { :maximum => 50 }
  validates :last_name, :presence => true,
                    :length   => { :maximum => 50 }               
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  
  # Automatically creates virtual attribute "password_confirmation"
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 4..40 },
                       :on => :create
                       
  

  
 # before_save :encrypt_password

  def feed
    Micropost.where("user_id = ?", id)
  end
  
  def my_conversations
    conversations.joins( "LEFT JOIN votes ON votes.micropost_id = conversations.micropost_id AND votes.user_id = conversations.user_id").where("votes.id IS NULL").order("conversations.created_at DESC")
  end

  # Return true if user's password matches submitted_password
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    # Handle password mismatch implicitly (returns nil)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  # ----------------------------------------------------------------------------------------------
  # leaderboards for scores twitter overall

  

  def self.leaderboard
     User.joins(:school).where('schools.visible' => true).where("users.has_voted" => true).order("users.total_score DESC")
  end
  
  def self.leaderboard_my_vote_real
       User.joins(:school).where('schools.visible' => true).where("users.has_voted" => true).order("users.votes_real DESC")
  end 
  
  def self.leaderboard_my_vote_fake
      User.joins(:school).where('schools.visible' => true).where("users.has_voted" => true).order("users.votes_fake DESC")
  end
  
  def self.leaderboard_voting_my_real
       User.joins(:school).where('schools.visible' => true).where("users.has_voted" => true).order("users.voting_real DESC")
  end 
  
  def self.leaderboard_voting_my_fake
      User.joins(:school).where('schools.visible' => true).where("users.has_voted" => true).order("users.voting_fake DESC")
  end
  
  # ----------------------------------------------------------------------------------------------
  # summary leaderboards for position overall
  
  def split_leaderboard(n, rs)
     p = rs.index(self)

      case p
      when  0
        return rs.slice(0..4)
      when 1
        return rs.slice(0..4)
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
        return rs.slice(s..e)
      end
  end
  
  def leaderboard_twittest
    n = User.all.count.where(:has_voted => true)
    if n <= 5
      return User.leaderboard
    else
      split_leaderboard(n, User.leaderboard)
    end
  end
  
  def leaderboard_twittest_my_vote_real
    n = User.all.count.where(:has_voted => true)
    if n <= 5
      return User.leaderboard_my_vote_real
    else
      split_leaderboard(n, User.leaderboard_my_vote_real)
    end
  end
   
   def leaderboard_twittest_my_vote_fake
       n = User.all.count.where(:has_voted => true)
       if n <= 5
         return User.leaderboard_my_vote_fake
       else
         split_leaderboard(n, User.leaderboard_my_vote_fake)
       end
     end

   def leaderboard_twittest_voting_my_real
      n = User.all.count.where(:has_voted => true)
      if n <= 5
        return User.leaderboard_voting_my_real
      else
        split_leaderboard(n, User.leaderboard_voting_my_real)
      end
    end
  
    def leaderboard_twittest_voting_my_fake
     n = User.all.count.where(:has_voted => true)
     if n <= 5
       return User.leaderboard_voting_my_fake
     else
       split_leaderboard(n, User.leaderboard_voting_my_fake)
     end
   end
  

  # ----------------------------------------------------------------------------------------------
  # position for user overal on twittest
  
  def position_overall
    (User.leaderboard.index(self) + 1).ordinalize
  end
   
  def position_twittest_my_vote_real
    (User.leaderboard_my_vote_real.index(self) + 1).ordinalize
  end
  
  def position_twittest_my_vote_fake
    (User.leaderboard_my_vote_fake.index(self) + 1).ordinalize
  end
  
  def position_twittest_voting_my_real
    (User.leaderboard_voting_my_real.index(self) + 1).ordinalize
  end
  
  def position_twittest_voting_my_fake
    (User.leaderboard_voting_my_fake.index(self) + 1).ordinalize
  end
  
  
  
  
  # ----------------------------------------------------------------------------------------------
  # position in users school
  
  def position_in_school
    (School.find_by_id(self.school_id).users_leaderboard.index(self) + 1).ordinalize
  end
  
  def position_in_school_my_votes_real
    (School.find_by_id(self.school_id).users_leaderboard_votes_real.index(self) + 1).ordinalize
  end
  
  def position_in_school_my_votes_fake
    (School.find_by_id(self.school_id).users_leaderboard_votes_fake.index(self) + 1).ordinalize
  end
  
  def position_in_school_voting_my_real
    (School.find_by_id(self.school_id).users_leaderboard_voting_real.index(self) + 1).ordinalize
  end
  
  def position_in_school_voting_my_fake
    (School.find_by_id(self.school_id).users_leaderboard_voting_fake.index(self) + 1).ordinalize
  end
  

  
  

  
  # ----------------------------------------------------------------------------------------------
  # leaderboards for position in users school
  
  def leaderboard_school
    n = School.find_by_id(self.school_id).users_leaderboard.count
    if n <= 5
      return School.find_by_id(self.school_id).users_leaderboard
    else
       split_leaderboard(n, School.find_by_id(self.school_id).users_leaderboard)
    end
  end
  
  def leaderboard_school_my_vote_real
     n = School.find_by_id(self.school_id).users_leaderboard_votes_real.count
      if n <= 5
        return School.find_by_id(self.school_id).users_leaderboard_votes_real
      else
        split_leaderboard(n, School.find_by_id(self.school_id).users_leaderboard_votes_real)
      end
  end
  
  def leaderboard_school_my_vote_fake
     n = School.find_by_id(self.school_id).users_leaderboard_votes_fake.count
      if n <= 5
        return School.find_by_id(self.school_id).users_leaderboard_votes_fake
      else
         split_leaderboard(n, School.find_by_id(self.school_id).users_leaderboard_votes_fake)
      end
  end
  
  def leaderboard_school_voting_my_real
     n = School.find_by_id(self.school_id).users_leaderboard_voting_real.count
      if n <= 5
        return School.find_by_id(self.school_id).users_leaderboard_voting_real
      else
        split_leaderboard(n, School.find_by_id(self.school_id).users_leaderboard_voting_real)
      end
  end
  
  def leaderboard_school_voting_my_fake
     n = School.find_by_id(self.school_id).users_leaderboard_voting_fake.count
      if n <= 5
        return School.find_by_id(self.school_id).users_leaderboard_voting_fake
      else
        split_leaderboard(n, School.find_by_id(self.school_id).users_leaderboard_voting_fake)
      end
  end
  
  # ----------------------------------------------------------------------------------------------

  def score
    n = self.score_voting + self.score_tweeting
    return n
  end
  
  def score_voting
    n = self.score_vote_real_correct  + self.score_vote_fake_spotted  + self.score_vote_fake_partial - self.score_vote_real_incorrect - self.score_vote_fake_fooled
    return n    
  end

  def score_tweeting
     n = self.score_tweet_real_agreed  + self.score_tweet_fake_fooled + self.score_tweet_fake_partial - self.score_tweet_real_disagreed - self.score_tweet_fake_spotted
     return n
  end
  
  def score_my_vote_real
    self.score_vote_real_correct - self.score_vote_real_incorrect
  end
  
  def score_my_vote_fake
    self.score_vote_fake_spotted + self.score_vote_fake_partial - self.score_vote_fake_fooled
  end
  
  def score_voting_my_real
    self.score_tweet_real_agreed  - self.score_tweet_real_disagreed
  end
  
  def score_voting_my_fake
    self.score_tweet_fake_fooled + self.score_tweet_fake_partial - self.score_tweet_fake_spotted
  end
  
  # ----------------------------------------------------------------------------------------------

  def score_vote_real_correct
    n = Vote.vote_real_correct(self.id) * 10 
    return n
  end
  
  def score_vote_real_incorrect
    n = Vote.vote_real_incorrect(self.id) * 10 
    return n
  end

  def score_vote_fake_spotted
    n = Vote.vote_fake_spotted(self.id) * 10
    return n
  end

  def score_vote_fake_fooled
     n = Vote.vote_fake_fooled(self.id) * 10
     return n
  end
 
  def score_vote_fake_partial
    n = Vote.vote_fake_partial(self.id) * 4
    return n
  end

  def score_tweet_real_agreed
    n = Vote.tweet_real_agreed(self.id) * 10 
    return n
  end

  def score_tweet_real_disagreed
    n = Vote.tweet_real_disagreed(self.id) * 10
    return n
  end

  def score_tweet_fake_fooled
    n = Vote.tweet_fake_fooled(self.id) * 10
    return n
  end

  def score_tweet_fake_spotted
    n = Vote.tweet_fake_spotted(self.id) * 10
    return n
  end
  
  def score_tweet_fake_partial
    n = Vote.tweet_fake_partial(self.id) * 2
    return n
  end

  # ----------------------------------------------------------------------------------------------



  

    def encrypt_password
      # new_record? returns true if object has not yet been saved to DB
      # In this case, it ensures that salt is only created once, when user is
      # created.
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
      private
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

