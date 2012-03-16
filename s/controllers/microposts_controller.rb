class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy]

  def index
    @microposts = current_user.microposts.paginate(:page => params[:page])
  end

  def create
    #raise params[:user].inspect
    
    if params[:micropost][:content].empty?
      flash[:error] = "There has been a problem saving your tweet. You must enter a message."
      redirect_to request.referer
    elsif Micropost.same_content?(current_user.id, params[:micropost][:content], params[:micropost][:turing_user_id])
      flash[:error] = "You have already created a tweet for that identity with the same content today."
      redirect_to request.referer
    else
      @micropost = current_user.microposts.build(params[:micropost])
      if @micropost.save
        flash[:success] = "Tweet created!"
        redirect_to request.referer
      else
        @feed_items = []
        render 'pages/home'
      end
    end
  end

  def destroy
    if @micropost.votes.empty?
      @micropost.destroy
      flash[:success] = "Tweet destroyed!"
    else
      flash[:success] = "Cannot delete the tweet as it has votes"
    end
    redirect_to request.referer
  end

  private
    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to(root_path) unless current_user?(@micropost.user)
    end
end
