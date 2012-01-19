
class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @vote = Vote.new
      @feed_items = Micropost.all_tweets(:id => current_user.id).paginate(:page => params[:page])
      @turing_users = TuringUser.all
      @conversation = Conversation.new
      @school_leaderboard = School.leaderboard_summary(current_user.school.id)
      @twittest_leaderboard = current_user.leaderboard_twittest
      @myschool_leaderboard = current_user.leaderboard_school
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
       @school_leaderboard = School.leaderboard_summary(current_user.school.id)
       @twittest_leaderboard = current_user.leaderboard_twittest
       @myschool_leaderboard = current_user.leaderboard_school
     end
   end

  def mytweets
    @title = "My Tweets"
    if signed_in?
       @micropost = Micropost.new
       @feed_items = current_user.microposts.paginate(:page => params[:page])
       @turing_users = TuringUser.all
       @school_leaderboard = School.leaderboard_summary(current_user.school.id)
       @twittest_leaderboard = current_user.leaderboard_twittest
       @myschool_leaderboard = current_user.leaderboard_school
    end
  end
  
  def myconversations
    @title = "My Conversations"
    if signed_in?
        @micropost = Micropost.new
        @feed_items = current_user.conversations.paginate(:page => params[:page])
        @turing_users = TuringUser.all
        @conversation_thread = ConversationThread.new
        @school_leaderboard = School.leaderboard_summary(current_user.school.id)
        @twittest_leaderboard = current_user.leaderboard_twittest
        @myschool_leaderboard = current_user.leaderboard_school
    end
  end
  

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
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
    @twittest_leaderboard = current_user.leaderboard_twittest_my_vote_real
  end

  def votesfake
    @title = "My Votes on Fake Tweets"
    @school_leaderboard = current_user.leaderboard_school_my_vote_fake
    @twittest_leaderboard = current_user.leaderboard_twittest_my_vote_fake
  end
  
  def votingreal
    @title = "Voting on My Real Tweets"
    @school_leaderboard = current_user.leaderboard_school_voting_my_real
    @twittest_leaderboard = current_user.leaderboard_twittest_voting_my_real
  end
  
  def votingfake
    @title = "Voting on My Fake Tweets"
    @school_leaderboard = current_user.leaderboard_school_voting_my_fake
    @twittest_leaderboard = current_user.leaderboard_twittest_voting_my_fake
  end

end
