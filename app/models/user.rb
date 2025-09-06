class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trades, dependent: :destroy

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_trades, through: :likes, source: :trade

  has_one_attached :avatar # プロフィール画像

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  


  def already_liked?(trade)
    self.likes.exists?(trade_id: trade.id)
  end

end
