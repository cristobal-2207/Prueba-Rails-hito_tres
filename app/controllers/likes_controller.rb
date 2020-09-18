class LikesController < ApplicationController

  before_action :set_tweet, only: [:show, :edit,:update,:destroy, :complete]
  
  def new
    @like= Like.new
  end
  
  def create
    tweet =Tweet.find_by(id:params[:format])
    if Like.find_by(user_id:current_user.id,tweet_id:tweet.id )
      @destruir= Like.find_by(user_id:current_user.id,tweet_id:tweet.id)
      @destruir.destroy
      tweet.likes_count-=1
      tweet.save
      redirect_to root_path
    else
      Like.create(user_id:current_user.id, tweet_id:tweet.id)
      tweet.likes_count+=1
      tweet.save
      redirect_to root_path
    end
  end

  def destroy
  end

private

  def like_params
    params.require(:like).permit(:user_id,:tweet_id)
  end
  
  def set_like
    @like = Like.find(params[:id])
  end
  
end