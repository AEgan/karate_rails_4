require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # validations
  # relationships will go here when available
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:date_of_birth)
  should validate_numericality_of(:rank).only_integer

  # testing values
  # good for phone
  should allow_value("1231231234").for(:phone)
  should allow_value("123-123-1234").for(:phone)
  should allow_value("123.123.1234").for(:phone)
  should allow_value("(123) 123-1234").for(:phone)
  should allow_value("").for(:phone)
  should allow_value(nil).for(:phone)
  # bad for phone
  should_not allow_value("12345678901").for(:phone)
  should_not allow_value("12345678").for(:phone)
  should_not allow_value("123 123 1234").for(:phone)
  should_not allow_value("1234 123 123").for(:phone)
  should_not allow_value("123-1234-123").for(:phone)
  should_not allow_value("123-EAT-FOOD").for(:phone)
  should_not allow_value("123/123/1234").for(:phone)

  # good for rank
  should allow_value(1).for(:rank)
  should allow_value(10).for(:rank)
  should allow_value(30).for(:rank)
  should allow_value("4").for(:rank)
  # bad for rank
  should_not allow_value(0).for(:rank)
  should_not allow_value(-1).for(:rank)
  should_not allow_value("").for(:rank)
  should_not allow_value(nil).for(:rank)
  should_not allow_value(3.15).for(:rank)
  should_not allow_value("abc").for(:rank)

  # good for active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  # bad for active
  should_not allow_value("").for(:active)
  should_not allow_value(nil).for(:active)

  # testing students with context
  context "creating context for students" do
  	# set up the context
  	setup do
  		@alex = FactoryGirl.create(:student)
  		@ryan = FactoryGirl.create(:student, first_name: "Ryan", rank: 1, waiver_signed: false, date_of_birth: 22.years.ago.to_date)
  		@matt = FactoryGirl.create(:student, first_name: "Matt", last_name: "Smith", rank: 5, active: false, date_of_birth: 7.years.ago.to_date + 1.day)
  		@mike = FactoryGirl.create(:student, first_name: "Mike", last_name: "Barton", rank: 12, waiver_signed: false, date_of_birth: 18.years.ago.to_date + 1.day)
  		@john = FactoryGirl.create(:student, first_name: "John", last_name: "Oswald", rank: 2, active: false, date_of_birth: 9.years.ago.to_date)
  	end

  	# tear down the context 
  	teardown do
  		@alex.destroy
  		@ryan.destroy
  		@matt.destroy
  		@mike.destroy
  		@john.destroy
  	end

  	# tests the factories for tests 
  	should "have working factories for testing" do
  		assert_equal "Alex", @alex.first_name
  		assert_equal "Ryan", @ryan.first_name
  		assert_equal "Matt", @matt.first_name
  		assert_equal "Mike", @mike.first_name
  		assert_equal "John", @john.first_name
  	end

  	# scopes
  	# alphabetical scope
  	should "have a scope to return students in alphabetical order" do
  		results = Student.alphabetical
  		assert_equal 5, results.size
  		# I map first names instead of just the object itself for the "expected" "actual" results in console, making them easier to read
  		assert_equal [@mike.first_name, @alex.first_name, @ryan.first_name, @john.first_name, @matt.first_name], results.map { |student| student.first_name }
  	end

  	# active scope
  	should "have a scope that returns students that are active" do
  		active_results = Student.active
  		assert_equal 3, active_results.size
  		assert active_results.include?(@alex)
  		assert active_results.include?(@ryan)
  		assert active_results.include?(@mike)
  		deny active_results.include?(@matt)
  		deny active_results.include?(@john)
  	end

  	# inactive scope
  	should "have a scope to return the inactive students" do
  		inactive_results = Student.inactive
  		assert_equal 2, inactive_results.size
  		assert inactive_results.include?(@matt)
  		assert inactive_results.include?(@john)
  		deny inactive_results.include?(@alex)
  		deny inactive_results.include?(@ryan)
  		deny inactive_results.include?(@mike)
  	end

  	# dans
  	should "have a scope to return only dans" do
  		dan_results = Student.dans
  		assert_equal 2, dan_results.size
  		assert dan_results.include?(@alex)
  		assert dan_results.include?(@mike)
  		deny dan_results.include?(@ryan)
  		deny dan_results.include?(@matt)
  		deny dan_results.include?(@john)
  	end

  	# gups
  	should "have a scope to return only gups" do
  		gup_results = Student.gups
  		assert_equal 3, gup_results.size
  		assert gup_results.include?(@ryan)
  		assert gup_results.include?(@matt)
  		assert gup_results.include?(@john)
  		deny gup_results.include?(@alex)
  		deny gup_results.include?(@mike)
  	end

  	# has waiver
  	should "have a scope that returns only students that have a waiver signed" do
  		signed_results = Student.has_waiver
  		assert_equal 3, signed_results.size
  		assert signed_results.include?(@alex)
  		assert signed_results.include?(@matt)
  		assert signed_results.include?(@john)
  		deny signed_results.include?(@ryan)
  		deny signed_results.include?(@mike)
  	end

  	# needs waiver
  	should "have a scope that returns only students that do not have a waiver signed" do
  		needs_results = Student.needs_waiver
  		assert_equal 2, needs_results.size
  		deny needs_results.include?(@alex)
  		deny needs_results.include?(@matt)
  		deny needs_results.include?(@john)
  		assert needs_results.include?(@ryan)
  		assert needs_results.include?(@mike)
  	end

  	# juniors
  	should "have a scope that returns only students who are less than 18 years old" do
  		junior_results = Student.juniors
  		assert_equal 3, junior_results.size
  		assert junior_results.include?(@matt)
  		assert junior_results.include?(@mike)
  		assert junior_results.include?(@john)
  		deny junior_results.include?(@alex)
  		deny junior_results.include?(@ryan)
  	end

  	# seniors
  	should "have a scope that returns only students who are 18 years old or older" do
  		senior_results = Student.seniors
  		assert_equal 2, senior_results.size
  		assert senior_results.include?(@alex)
  		assert senior_results.include?(@ryan)
  		deny senior_results.include?(@matt)
  		deny senior_results.include?(@mike)
  		deny senior_results.include?(@john)
   	end

   	# by rank
   	should "have a scope to return students in rank order" do
   		ranked_results = Student.by_rank
   		assert_equal 5, ranked_results.size
   		# I map first names instead of just the object itself for the "expected" "actual" results in console, making them easier to read
   		assert_equal [@mike.first_name, @alex.first_name, @matt.first_name, @john.first_name, @ryan.first_name], ranked_results.map { |student| student.first_name }
   	end

  end
end
