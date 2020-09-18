class Retweet < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  scope :retweets_for_me, -> (ids){where(user_id: ids)}
end
