class Like < ApplicationRecord
  belongs_to :user
  belongs_to :trade

  validates_uniqueness_of :trade_id, scope: :user_id

  def self.mutual_like?(user, trade)
    # 相手が user の投稿に既にいいねしているか
    Like.exists?(user: trade.user, trade: user.trades)
  end

  
end
