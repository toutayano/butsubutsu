class Room < ApplicationRecord
    belongs_to :trade, optional: true
    has_many :messages, dependent: :destroy
    has_many :entries, dependent: :destroy

    belongs_to :user1, class_name: "User"
    belongs_to :user2, class_name: "User"

    has_many :messages, dependent: :destroy

    def self.between(user_a, user_b)
    where(user1: user_a, user2: user_b)
      .or(where(user1: user_b, user2: user_a))
      .first
    end
end
