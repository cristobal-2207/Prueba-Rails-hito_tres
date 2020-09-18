class ApisController < ApplicationController

  skip_before_action :verify_authenticity_token 

  def rescue_latest_tweets
    if Tweet.all
      
      @retweets = Retweet.group(:tweet_id).order('created_at DESC') 
      tweets=[]
      @tweets=Tweet.all.order('created_at DESC').limit(50)
      
      @tweets.each do |tweet|
        tweets << { id: tweet.id, content: tweet.content,user_id: tweet.user_id, likes_count: tweet.likes_count,retweets_count: tweet.retweets_count,rewtitted_from: @retweets.map{|retweet|tweet.id == retweet.tweet_id ? retweet.user_id : ""}.select{|v|v!=""}.to_s.tr('[]', '').to_i} 
      end
        render json: tweets, status: :ok
    else
      render json: {status: "error", code: 3000, message: "Can't find the date"}
    end
  end

  def rescue_last_dates
    @retweets=Retweet.group(:tweet_id).order('created_at DESC') 
    @from=params[:from]
    @to_date=params[:to]
    @tweets=Tweet.where(created_at:@from.. @to_date) 
    if @tweets!=[]
      render json: @tweets, status: :ok
    else
      render json: {status: "error", code: 3000, message: "No encuentro tu custión"}
    end 
  end
  
  def tweet_with_postman
    if !current_user
      render json: {status: "error", code: 3000, message: "You aren't log in"}
      else
      @tweet=Tweet.new(tweet_params)
      @tweet.user_id=current_user.id
      
      if @tweet.save
        render json: @tweet , status: :created
      else
        render json: {status: "error", code: 3000, message: "You aren't log in"}
      end
    end
  end

private

  def tweet_params
    params.require(:tweet).permit(:content,:likes_count,:retweets_count,:user_id)
  end 
  
end
