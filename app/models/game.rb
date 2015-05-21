class Game < ActiveRecord::Base
		# Already have a table called 'game' in the DB
		belongs_to :cups
end
