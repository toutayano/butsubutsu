class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room, optional: true    # DM用
  belongs_to :trade, optional: true   # 投稿チャット用

  validates :content, presence: true
  has_many :notifications, dependent: :destroy
end