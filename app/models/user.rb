class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token

	has_secure_password

	before_save 	:downcase_email
	before_create :create_activation_digest

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name , 	presence: 	true,
						length: 	{ maximum: 50 }
	validates :email, 	presence: 	true, 
						length: 	{ maximum: 255 },
						format: 	{ with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }, allow_blank: true

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def remember
		# create and assign a remember token
		self.remember_token = User.new_token
		# hash and place digest in db
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	private

		# Converts email to all lowercase
		def downcase_email	
			# downcase all emails so that db's w/ case-sensitive indices treat
			# case-inconsistent email addresses as the same address
			# 
			# we use a callback: a method invoked at a particular point in the lifcucle
			# of an Active Record object. So this call gets made for every User instance
			# just before it gets saved to the db. It takes in a block
			self.email = email.downcase
		end

		# Creates and assigns the activation token and digest
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end

end
