class User < ActiveRecord::Base

  attr_accessor :remember_token

	validates :nombre,  presence: true, length: {maximum: 50}
	validates :apellido,  presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 150}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :profesion, presence: true, length: {maximum: 150}
  validates :numero_fijo, length: {maximum: 11}
  validates :numero_celular, length: {maximum: 12}
  validates :municipio, length: {maximum: 150}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  def User.digest(string)

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)

  end
  
  def User.new_token

    SecureRandom.urlsafe_base64

  end

  def remember

    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    
  end

  def authenticated?(remember_token)

    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)

  end

  def forget

    update_attribute(:remember_digest, nil)
    
  end

end
