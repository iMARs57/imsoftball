class Cup < ActiveRecord::Base
		# Already have a table called 'cup' in the DB
	has_many :games
end
