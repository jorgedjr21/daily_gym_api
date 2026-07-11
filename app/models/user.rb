class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  has_many :workout_plans, dependent: :destroy
  has_many :workout_sessions, dependent: :destroy

  ROLES = %w[admin member].freeze

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :role, inclusion: { in: ROLES }, allow_nil: false

  private

  def password_required?
    new_record? || password.present?
  end
end
