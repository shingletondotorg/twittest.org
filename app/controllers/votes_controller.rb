class VotesController < ApplicationController
  def new
  end
  
  def destroy
  end
  
  def create
     @vote = Vote.new(params[:vote])
      if @vote.save
        flash[:success] = "Vote cast!"
        redirect_to root_path
      else
         @feed_items = []
          render 'pages/home'
      end
  end
  
end
