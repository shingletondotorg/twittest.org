
class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @vote = Vote.new
      @feed_items = Micropost.all_tweets(:id => current_user.id).paginate(:page => params[:page])
      @turing_users = TuringUser.all
      @conversation = Conversation.new
      @myschool_leaderboard = current_user.leaderboard_school
      if current_user.school.visible 
        @twittest_leaderboard = current_user.leaderboard_twittest
        @school_leaderboard = School.leaderboard_summary(current_user.school.id)
      end 
    end
  end
  
  def voteontweets
     @title = "Vote on Tweets"
     if signed_in?
       @micropost = Micropost.new
       @vote = Vote.new
       @feed_items = Micropost.not_voted(:id => current_user.id).paginate(:page => params[:page])
       @turing_users = TuringUser.all
       @conversation_thread = ConversationThread.new
       @myschool_leaderboard = current_user.leaderboard_school
        if current_user.school.visible 
          @twittest_leaderboard = current_user.leaderboard_twittest
          @school_leaderboard = School.leaderboard_summary(current_user.school.id)  
        end
     end
   end

  def mytweets
    @title = "My Tweets"
    if signed_in?
       @micropost = Micropost.new
       @feed_items = current_user.microposts.paginate(:page => params[:page])
       @turing_users = TuringUser.all
       @myschool_leaderboard = current_user.leaderboard_school
       if current_user.school.visible 
        @twittest_leaderboard = current_user.leaderboard_twittest
        @school_leaderboard = School.leaderboard_summary(current_user.school.id)  
       end
    end
  end
  
  def myconversations
    @title = "My Conversations"
    if signed_in?
        @micropost = Micropost.new
        @feed_items = current_user.my_conversations.paginate(:page => params[:page])
        @turing_users = TuringUser.all
        @conversation_thread = ConversationThread.new
        @myschool_leaderboard = current_user.leaderboard_school
        if current_user.school.visible 
          @twittest_leaderboard = current_user.leaderboard_twittest
          @school_leaderboard = School.leaderboard_summary(current_user.school.id)  
        end
    end
  end
  

  def contact
    @title = "Contact"
  end

  def about
    @title = "About Turing Test"
  end
  
  def twitter
    @title = "About Twitter"
  end
  
  def chatbots
    @title = "About Chatbots"
  end
  
  def communications
    @title = "Deception and Online Communication"
  end

  def winning
    @title = "Strategies for Winning"
  end
  
  def help
    @title = "Help"
  end
  
  def score
    @title = "Score"
  end

  def votesreal
    @title = "My Votes on Real Tweets"
    @school_leaderboard = current_user.leaderboard_school_my_vote_real
    if current_user.school.visible 
      @twittest_leaderboard = current_user.leaderboard_twittest_my_vote_real
    end
  end

  def votesfake
    @title = "My Votes on Fake Tweets"
    @school_leaderboard = current_user.leaderboard_school_my_vote_fake
    if current_user.school.visible 
      @twittest_leaderboard = current_user.leaderboard_twittest_my_vote_fake
    end
  end
  
  def votingreal
    @title = "Voting on My Real Tweets"
    @school_leaderboard = current_user.leaderboard_school_voting_my_real
    if current_user.school.visible 
      @twittest_leaderboard = current_user.leaderboard_twittest_voting_my_real
    end
  end
  
  def votingfake
    @title = "Voting on My Fake Tweets"
    @school_leaderboard = current_user.leaderboard_school_voting_my_fake
    if current_user.school.visible 
      @twittest_leaderboard = current_user.leaderboard_twittest_voting_my_fake
    end
  end
  
  def activityone
    @title = "Activity 1 - Turing Test Groups"
  end
  
  def activitytwo
    @title = "Activity 2 - Tweet Cards"
  end
  
  def activitythree
    @title = "Activity 3 - Identity Play"
  end
  
  def activityfour
    @title = "Activity 4 - Logging and Trial Twittest"
  end
  
  def interest
     @title = "Register Your Interest"
  end
  

end
