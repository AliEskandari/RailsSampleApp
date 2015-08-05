class User < ActiveRecord::Base

	# downcase all emails so that db's w/ case-sensitive indices treat
	# case-inconsistent email addresses as the same address
	# 
	# we use a callback: a method invoked at a particular point in the lifcucle
	# of an Active Record object. So this call gets made for every User instance
	# just before it gets saved to the db. It takes in a block
	before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name , 	presence: 	true,
						length: 	{ maximum: 50 }
	validates :email, 	presence: 	true, 
						length: 	{ maximum: 255 },
						format: 	{ with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
end
