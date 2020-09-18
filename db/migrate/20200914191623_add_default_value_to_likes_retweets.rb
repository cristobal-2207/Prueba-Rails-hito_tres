class AddDefaultValueToLikesRetweets < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tweets, :likes_count, from: nil, to: 0
    change_column_default :tweets, :retweets_count, from: nil, to: 0 
  end
end
