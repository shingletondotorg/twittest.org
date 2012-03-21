class Vote < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :voter, :class_name => "User", :foreign_key => 'user_id'

  attr_accessible :user_id, :micropost_id, :vote

  validates :user_id, :uniqueness => {:scope => :micropost_id}

  def self.vote_real_correct(id)
    Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id != ? AND votes.user_id = ?" ,id, id ).count
  end

  def self.vote_real_incorrect(id)
    Vote.joins( :micropost => :user ).where( "votes.vote != microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id != ? AND votes.user_id = ?" ,id, id ).count
  end

  def self.tweet_real_agreed(id)
    Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id ).count
  end

  def self.tweet_real_disagreed(id)
    Vote.joins( :micropost => :user ).where( "votes.vote != microposts.turing_user_id AND microposts.turing_user_id = users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
  end

  def self.vote_fake_spotted(id)
    Vote.joins( :micropost => :user ).where( "votes.vote = users.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND votes.user_id = ? AND microposts.user_id != ?" ,id, id).count
  end

  def self.vote_fake_fooled(id)
    Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND votes.user_id = ? AND microposts.user_id != ?" ,id, id).count
  end

  def self.vote_fake_partial(id)
    Vote.joins( :micropost => :user ).where( "votes.vote != users.turing_user_id AND votes.vote != microposts.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND votes.user_id = ? AND microposts.user_id != ?" ,id, id).count
  end

  def self.tweet_fake_fooled(id)
    Vote.joins( :micropost => :user ).where( "votes.vote = microposts.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
  end

  def self.tweet_fake_spotted(id)
    Vote.joins( :micropost => :user ).where( "votes.vote = users.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
  end

  def self.tweet_fake_partial(id)
    Vote.joins( :micropost => :user ).where( "votes.vote != microposts.turing_user_id AND votes.vote != users.turing_user_id AND microposts.turing_user_id != users.turing_user_id AND microposts.user_id = ? AND votes.user_id != ?" ,id, id).count
  end


  def update_score()
    micropost = Micropost.find_by_id(self.micropost_id)
    tweet_user = User.find_by_id(micropost.user_id)
    voting_user = User.find_by_id(self.user_id)

    # author is posting as themselves
    if micropost.user.turing_user_id == micropost.turing_user_id
      
      case micropost.user.turing_user_id
      # student as student
      when 1
        case self.vote
        when 1
          voting_user.voting_real = voting_user.voting_real + 2
          tweet_user.votes_real = tweet_user.votes_real     + 1
        when 2
          voting_user.voting_real = voting_user.voting_real - 15
          tweet_user.votes_real = tweet_user.votes_real     - 10
        when 3
          voting_user.voting_real = voting_user.voting_real - 10
          tweet_user.votes_real = tweet_user.votes_real     - 5
        else #4
          voting_user.voting_real = voting_user.voting_real - 10
          tweet_user.votes_real = tweet_user.votes_real     - 5
        end     
      # teacher as teacher  
      when 2
        case self.vote
        when 1
          voting_user.voting_real = voting_user.voting_real - 50
          tweet_user.votes_real = tweet_user.votes_real     - 5
        when 2
          voting_user.voting_real = voting_user.voting_real + 50
          tweet_user.votes_real = tweet_user.votes_real     + 25
        when 3
          voting_user.voting_real = voting_user.voting_real - 5
          tweet_user.votes_real = tweet_user.votes_real     - 5
        else # 4
          voting_user.voting_real = voting_user.voting_real - 10
          tweet_user.votes_real = tweet_user.votes_real     - 5
        end
      #c elebrity as celebrity  
      when 3
        case self.vote
        when 1
          voting_user.voting_real = voting_user.voting_real - 50
          tweet_user.votes_real = tweet_user.votes_real     - 5
        when 2
          voting_user.voting_real = voting_user.voting_real - 15
          tweet_user.votes_real = tweet_user.votes_real     - 10
        when 3
          voting_user.voting_real = voting_user.voting_real + 100
          tweet_user.votes_real = tweet_user.votes_real     + 50
        else # 4
          voting_user.voting_real = voting_user.voting_real - 10
          tweet_user.votes_real = tweet_user.votes_real     - 5
        end
      # twitbot as twitbot  
      else # 4
        case self.vote
        when 1
          voting_user.voting_real = voting_user.voting_real - 50
          tweet_user.votes_real = tweet_user.votes_real     - 5
        when 2
          voting_user.voting_real = voting_user.voting_real - 15
          tweet_user.votes_real = tweet_user.votes_real     - 10
        when 3
          voting_user.voting_real = voting_user.voting_real - 5
          tweet_user.votes_real = tweet_user.votes_real     - 5
        else # 4
          voting_user.voting_real = voting_user.voting_real + 75
          tweet_user.votes_real = tweet_user.votes_real     + 10
        end
      
      end
      
    # author is posting as another identity  
    else

      # student as teacher
      if micropost.user.turing_user_id == 1 && micropost.turing_user_id == 2
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    + 5
          tweet_user.votes_fake = tweet_user.votes_fake        - 10 
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 100
          tweet_user.votes_fake = tweet_user.votes_fake        + 75
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 5 
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        end
      end

      # student as celebrity
      if micropost.user.turing_user_id == 1  &&  micropost.turing_user_id == 3
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    + 5
          tweet_user.votes_fake = tweet_user.votes_fake        - 10
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 15
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 100 
          tweet_user.votes_fake = tweet_user.votes_fake        + 125
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        end
      end

      # student as twitbot
      if micropost.user.turing_user_id == 1  &&  micropost.turing_user_id == 4
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    + 5
          tweet_user.votes_fake = tweet_user.votes_fake        - 10
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 15
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 100
          tweet_user.votes_fake = tweet_user.votes_fake        + 100
        end
      end

      # teacher faking student
      if micropost.user.turing_user_id == 2  &&  micropost.turing_user_id == 1
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 100
        when 2
          voting_user.voting_fake = voting_user.voting_fake    + 75
          tweet_user.votes_fake = tweet_user.votes_fake        - 100
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 5 
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        end
      end

      # teacher faking celebrity
      if micropost.user.turing_user_id == 2  &&  micropost.turing_user_id == 3
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    + 75
          tweet_user.votes_fake = tweet_user.votes_fake        - 100
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 100 
          tweet_user.votes_fake = tweet_user.votes_fake        + 75
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        end
      end

      # teacher faking twitbot
      if micropost.user.turing_user_id == 2  &&  micropost.turing_user_id == 4
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    + 75
          tweet_user.votes_fake = tweet_user.votes_fake        - 100
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 100
          tweet_user.votes_fake = tweet_user.votes_fake        + 75
        end
      end

      # celebrity faking student
      if micropost.user.turing_user_id == 3  &&  micropost.turing_user_id == 1
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 20
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 3
          voting_user.voting_fake = voting_user.voting_fake    + 125
          tweet_user.votes_fake = tweet_user.votes_fake        - 75
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 10
        end
      end

      # celebrity faking teacher
      if micropost.user.turing_user_id == 3  &&  micropost.turing_user_id == 2
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 30
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 3
          voting_user.voting_fake = voting_user.voting_fake    + 125
          tweet_user.votes_fake = tweet_user.votes_fake        - 75
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 10
        end
      end

      # celebrity faking twitbot
      if micropost.user.turing_user_id == 3  &&  micropost.turing_user_id == 4
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 30
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 20
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 3
          voting_user.voting_fake = voting_user.voting_fake    + 125
          tweet_user.votes_fake = tweet_user.votes_fake        - 75
        when 4
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 10
        end
      end

      # twitbot faking studnet
      if micropost.user.turing_user_id == 4  &&  micropost.turing_user_id == 1
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 100
          tweet_user.votes_fake = tweet_user.votes_fake        + 50
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 25
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 4
          voting_user.voting_fake = voting_user.voting_fake    + 75
          tweet_user.votes_fake = tweet_user.votes_fake        - 50
        end
      end

      # twitbot faking teacher
      if micropost.user.turing_user_id == 4  &&  micropost.turing_user_id == 2
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 75
          tweet_user.votes_fake = tweet_user.votes_fake        + 10
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 5
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 4
          voting_user.voting_fake = voting_user.voting_fake    + 75
          tweet_user.votes_fake = tweet_user.votes_fake        - 50
        end
      end

      # twitbot faking celeb
      if micropost.user.turing_user_id == 4  &&  micropost.turing_user_id == 3
        case self.vote
        when 1
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 5
        when 2
          voting_user.voting_fake = voting_user.voting_fake    - 25
          tweet_user.votes_fake = tweet_user.votes_fake        + 10
        when 3
          voting_user.voting_fake = voting_user.voting_fake    - 50
          tweet_user.votes_fake = tweet_user.votes_fake        + 25
        when 4
          voting_user.voting_fake = voting_user.voting_fake    + 75
          tweet_user.votes_fake = tweet_user.votes_fake        - 50
        end
      end
    end

    voting_user.total_score = voting_user.votes_fake + voting_user.votes_real + voting_user.voting_fake + voting_user.voting_real
    tweet_user.total_score = tweet_user.votes_fake + tweet_user.votes_real + tweet_user.voting_fake + tweet_user.voting_real

    voting_user.has_voted = true
    voting_user.save!
    tweet_user.save!
  end

end
