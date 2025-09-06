class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"    # 通知を受け取るユーザー
  belongs_to :actor, class_name: "User"        # 行動したユーザー（いいねした人など）
  belongs_to :trade, optional: true            # 該当の投稿
  belongs_to :room, optional: true             # DMルーム
  belongs_to :message, optional: true
  # 既読管理
  scope :unread, -> { where(read_at: nil) }
end
