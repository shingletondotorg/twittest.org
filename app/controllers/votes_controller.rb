class VotesController < ApplicationController
  
  def new
  end
  
  def destroy
  end
  
  def create
   
     @vote = Vote.new(params[:vote])
      if @vote.save
        flash[:success] = "Vote cast!"
        @vote.update_score
        redirect_to request.referer
      else
        @feed_items = []
        redirect_to request.referer
      end
  end
  
end
