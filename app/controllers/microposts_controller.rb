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
      m = current_user.microposts.build(params[:micropost])
      if m.save
        if ((current_user.turing_user_id != 1) or (current_user.turing_user_id == 1 && current_user.is_trusted))
          m.update_attributes(:is_visible => true)
        end
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

  def flag
    m = Micropost.find_by_id(params[:micropost][:micropost_id])
    m.update_attributes(:is_visible => false, :report_user => true)
    u = User.find_by_id(m.user_id)
    u.report_user
    flash[:success] = "Tweet reported"
    redirect_to request.referer
  end
  
  def approve
     m = Micropost.find_by_id(params[:micropost][:micropost_id])
     m.update_attributes(:is_visible => true, :report_user => false)
     u = User.find_by_id(m.user_id)
     u.approve_user
     flash[:success] = "Tweet approved"
     redirect_to request.referer
   end
   
   def penalise
      m = Micropost.find_by_id(params[:micropost][:micropost_id])
      m.update_attributes(:penalise_user => true)
      u = User.find_by_id(m.user_id)
      u.penalise
      flash[:success] = "User has been penalised"
      redirect_to request.referer
   end
  
  private
    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to(root_path) unless current_user?(@micropost.user)
    end
end
