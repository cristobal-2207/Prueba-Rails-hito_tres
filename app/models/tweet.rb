class Tweet < ApplicationRecord
  belongs_to :user
	has_many :likes
	has_many :retweets
	validates :content, presence: true 
	enum status: [:draft, :published]
	paginates_per 50
	scope :tweets_for_me, -> (ids){where(user_id: ids)} 
end
