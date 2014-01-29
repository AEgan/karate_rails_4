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
		association :tournament
		location "front"
		round_time Time.local(2000,1,1,11,0,0)
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

	# tournament factory
	factory :tournament do
		name "Grand Finals"
		date 3.weeks.from_now.to_date
		min_rank 1
		max_rank 15
		active true
	end

end