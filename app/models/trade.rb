class Trade < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many :messages, dependent: :destroy  # 投稿専用チャット用
  has_many :notifications, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :name, presence: true
  validates :category, presence: true
  validates :condition, presence: true
  validates :detail, presence: true
  validates :image, presence: true
end
