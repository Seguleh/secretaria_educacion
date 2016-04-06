class User < ActiveRecord::Base
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
end
