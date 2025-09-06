class Like < ApplicationRecord
  belongs_to :user
  belongs_to :trade

  validates_uniqueness_of :trade_id, scope: :user_id

end
