class User < ActiveRecord::Base
  validates :user_name, presence: true
  validates :user_name, uniqueness: true
  has_many :cats, dependent: :destroy

  attr_reader :password
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    # session[:token] = nil
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password_digest
    BCrypt::Password.new(super)
  end

  def is_password?(password)
    password_digest.is_password?(password)
  end

  after_initialize do |user|
    user.session_token ||= SecureRandom::urlsafe_base64
  end
end
