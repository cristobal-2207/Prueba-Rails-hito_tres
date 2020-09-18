class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :set_current_tweet, only: [:likes, :retweet]

  def index

    if !current_user

      @q=Tweet.ransack(params[:q])
      @tweets=@q.result.order('created_at DESC').page params[:page]
      @retweets=Retweet.all 

    else
      @q=Tweet.tweets_for_me(current_user.followings.pluck(:id)).ransack(params[:q])
      @tweets=@q.result.order('created_at DESC').page params[:page] 
      @retweets=Retweet.retweets_for_me(current_user.followings.pluck(:id)).order('created_at DESC').page params[:page]
      @tweet=Tweet.new  
    end

  end

  def show
    @likes = Like.all 
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user
    if @tweet.save
      redirect_to root_path
    else
      render 'new'
    end 
  end

  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def likes
    if @tweet.is_liked?(current_user)
      @tweet.remove_like(current_user)

    else
      @tweet.add_like(current_user)

    end 
    redirect_to root_path
  end

  def search
    @q=Tweet.ransack(content_cont_any: params[:search])
    @tweets=@q.result
  end 

  def retweet
    new_tweet = Tweet.create(content: @tweet.content, user: current_user, rt_ref:@tweet.id)
    redirect_to root_path
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def set_current_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :user)
    end
  
  def organized_pages
    @tweets = Tweet.order(:created_at).page params[:page]
  end  

end
