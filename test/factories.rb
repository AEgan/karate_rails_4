FactoryGirl.define do 

	# event factory
	factory :event do
		name "Breaking"
		active true
	end

	# student factory
	factory :student do 
		first_name "Alex"
		last_name "Egan"
		date_of_birth 21.years.ago.to_date
		rank 10
		phone "2155551234"
		waiver_signed true
		active true
	end

	# section factory
	factory :section do
		association :event
		min_age 5
		min_rank 1
		active true
	end

	# registration factory
	factory :registration do
		association :section
		association :student
		date 1.year.ago.to_date
	end

	# dojo factory
	factory :dojo do
	    name "CMU"
	    street "5000 Forbes Avenue"
	    city "Pittsburgh"
	    state "PA"
	    zip "15213"
	    active true
	end

	# dojo student factory
	factory :dojo_student do
		association :student
		association :dojo
		start_date 1.year.ago.to_date
		end_date nil
	end

	# user factory
	factory :user do
		association :student
		email "alex@example.com"
		role "member"
		password "secret"
		password_confirmation "secret"
		active true
	end


end