module ApplicationHelper
	# gets the name for a rank
	def rank_name(rank)
		if rank == 1
			"Tenth Gup"
		elsif rank == 2
			"Ninth Gup"
		elsif rank == 3
			"Eighth Gup"
		elsif rank == 4
			"Seventh Gup"
		elsif rank == 5
			"Sixth Gup"
		elsif rank == 6
			"Fifth Gup"
		elsif rank == 7
			"Fourth Gup"
		elsif rank == 8
			"Third Gup"
		elsif rank == 9
			"Second Gup"
		elsif rank == 10
			"First Gup"
		elsif rank == 11
			"First Dan"
		elsif rank == 12
			"Second Dan"
		elsif rank == 13
			"Third Dan"
		elsif rank == 14
			"Fourth Dan"
		else
			"Senior Master"
		end
	end				

	# makes the rank range easier to read
	def rank_range_for(section)
		if section.max_rank.nil?
			"#{rank_name(section.min_rank)} and Up"
		else
			"#{rank_name(section.min_rank)} - #{rank_name(section.max_rank)}"
		end
	end

	# makes the age range easier to read
	def age_range_for(section)
		if section.max_age.nil?
			"#{section.min_age} years old and Up"
		else
			"#{section.min_age} years old to #{section.max_age} years old"
		end
	end
end
