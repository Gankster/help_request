class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github google_oauth2]

  has_many :questions
  has_many :answers
  has_many :awards
  has_many :comments
  has_many :authorizations, dependent: :destroy

  def author?(resource)
    resource.try(:user_id) == id
  end
end
