class User < ActiveRecord::Base
	validates :first_name,  presence: true, length: {maximum: 50}
	validates :last_name,  presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  	validates :email, presence: true, length: {maximum: 150}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  	validates :profession, presence: true, length: {maximum: 150}
  	validates :phone_number, length: {maximum: 15}
  	validates :mobile_number, length: {maximum: 15}
  	validates :municipality, length: {maximum: 150}

  	has_secure_password
  	validates :password, presence: true, length: {minimum: 6}
end
