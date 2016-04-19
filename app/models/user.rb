class User < ActiveRecord::Base

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

	validates :nombre,  presence: true, length: {maximum: 50}
	validates :apellido,  presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 150}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :profesion, presence: true, length: {maximum: 150}
  validates :numero_fijo, length: {maximum: 11}
  validates :numero_celular, length: {maximum: 12}
  validates :municipio, length: {maximum: 150}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

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

  def authenticated?(attribute, token)

    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)

  end

  def forget

    update_attribute(:remember_digest, nil)
    
  end

  def activate

    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email

    UserMailer.account_activacion(self).deliver_now
  end

  def create_reset_digest

    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email

    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?

    reset_sent_at < 2.hours.ago
  end


  private

    def downcase_email

      self.email = email.downcase

    end

    def create_activation_digest

      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)

    end

end
