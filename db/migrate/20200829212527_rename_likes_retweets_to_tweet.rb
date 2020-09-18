class RenameLikesRetweetsToTweet < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :tweets, :likes, :likes_count
    rename_column :tweets, :retweets, :retweets_count
 end
 def self.down
    rename_column :tweets, :likes_count, :likes
    rename_column :tweets, :retweets_count, :retweets
 end
end
