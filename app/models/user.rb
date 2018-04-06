class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :fixes
  has_many :user_fixes, foreign_key: "mechanical_id", :class_name => "Fix"
  has_many :reviews, through: :user_fixes

  validates :name, presence: true
end
