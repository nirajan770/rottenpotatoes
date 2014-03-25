class Movie < ActiveRecord::Base
	## retrieves all the ratings value listed in the movies
	def self.all_ratings
		self.find(:all, :select=> "rating", :group=>"rating").map(&:rating)
	end
	
end
