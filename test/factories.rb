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

end