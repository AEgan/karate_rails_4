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

	# gets a rank list for section form. If it's max it allows for no max rank
	def get_rank_list(specifier)
		if(specifier == 'max')
			[['Tenth Gup', 1],['Ninth Gup', 2],['Eighth Gup', 3], ['Seventh Gup', 4],['Sixth Gup', 5],['Fifth Gup', 6], ['Fourth Gup', 7],['Third Gup', 8],['Second Gup', 9], ['First Gup', 10],['First Dan', 11],['Second Dan', 12], ['Third Dan', 13],['Fourth Dan', 14],['Senior Master', 15], ['none', nil]]
		else
			[['Tenth Gup', 1],['Ninth Gup', 2],['Eighth Gup', 3], ['Seventh Gup', 4],['Sixth Gup', 5],['Fifth Gup', 6], ['Fourth Gup', 7],['Third Gup', 8],['Second Gup', 9], ['First Gup', 10],['First Dan', 11],['Second Dan', 12], ['Third Dan', 13],['Fourth Dan', 14],['Senior Master', 15]]
		end
	end

	# formats a phone number to (XXX) XXX-XXXX
	def format_phone(phone)
		"(" + phone[0..2] + ") " + phone[3..5] + "-" + phone[6..9]+""
	end

	# formats date
	def format_date(date)
		"#{date.month}-#{date.day}-#{date.year}"
	end

	# eligable unregistered students
	def eligable_students_for_section(section)
		opts = Array.new
		Student.ranks_between(section.min_rank, section.max_rank).ages_between(section.min_age, section.max_age).active.each do |stud|
			if Registration.for_section(section.id).for_student(stud.id).empty?
				opts << ["#{stud.name}", stud.id]
			end
		end
		opts
	end
end
