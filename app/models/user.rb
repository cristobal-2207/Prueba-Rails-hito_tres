class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_many :tweets, :dependent => :destroy
         has_many :likes, :dependent => :destroy
         has_many :retweets, :dependent => :destroy

         has_many :account_following, foreign_key: :follower_id, class_name: "Follow",:dependent => :destroy
         has_many :followings, through: :account_following, source: :following,:dependent => :destroy

         has_many :account_follower, foreign_key: :following_id, class_name: "Follow" ,:dependent => :destroy
         has_many :followers, through: :account_follower, source: :follower ,:dependent => :destroy       
end
