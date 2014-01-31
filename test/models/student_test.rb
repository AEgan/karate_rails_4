require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # validations
  # relationships
  should have_many(:registrations)
  should have_many(:sections).through(:registrations)
  should have_many(:dojo_students)
  should have_many(:dojos).through(:dojo_students)
  should have_one(:user)

  # data format
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

   	# methods
   	# name
   	should "have a method to get a student's name in last, first format" do
   		# using #{@student.attr} instead of "Last Name" and "First Name" so if you change the factories the tests still work 
   		assert_equal "#{@alex.last_name}, #{@alex.first_name}", @alex.name
   		assert_equal "#{@ryan.last_name}, #{@ryan.first_name}", @ryan.name
   		assert_equal "#{@matt.last_name}, #{@matt.first_name}", @matt.name
   		assert_equal "#{@john.last_name}, #{@john.first_name}", @john.name
   		assert_equal "#{@mike.last_name}, #{@mike.first_name}", @mike.name
   	end

   	# proper name
   	should "have a method to get a student's name in first last format" do
   		# using #{@student.attr} instead of "Last Name" and "First Name" so if you change the factories the tests still work 
   		assert_equal "#{@alex.first_name} #{@alex.last_name}", @alex.proper_name
   		assert_equal "#{@ryan.first_name} #{@ryan.last_name}", @ryan.proper_name
   		assert_equal "#{@matt.first_name} #{@matt.last_name}", @matt.proper_name
   		assert_equal "#{@john.first_name} #{@john.last_name}", @john.proper_name
   		assert_equal "#{@mike.first_name} #{@mike.last_name}", @mike.proper_name
   	end

   	# age
   	should "have a method that returns a student's age" do
   		# not doing the same thing with names here because I'm lazy
   		assert_equal 21, @alex.age
   		assert_equal 22, @ryan.age
   		assert_equal 17, @mike.age
   		assert_equal 6,  @matt.age
   		assert_equal 9,  @john.age
   	end

   	# over_18
   	should "have a method that determines if a student is 18 or over" do
   		assert @alex.over_18?
   		assert @ryan.over_18?
   		deny   @mike.over_18?
   		deny   @matt.over_18?
   		deny   @john.over_18?
   	end

   	# ages between
   	should "have a method that returns students is in a given age range" do
   		ages_result1 = Student.ages_between(18, 22)
   		assert_equal 2, ages_result1.size
   		assert ages_result1.include?(@alex)
   		assert ages_result1.include?(@ryan)
   		deny ages_result1.include?(@matt)
   		deny ages_result1.include?(@mike)
   		deny ages_result1.include?(@john)
   		ages_result2 = Student.ages_between(5, 12)
   		assert_equal 2, ages_result2.size
   		assert ages_result2.include?(@matt)
   		assert ages_result2.include?(@john)
   		deny ages_result2.include?(@alex)
   		deny ages_result2.include?(@ryan)
   		deny ages_result2.include?(@mike)
   	end

   	# ranks between
   	should "have a method that returns students in a given rank range" do
   		rank_result1 = Student.ranks_between(1, 5)
   		assert_equal 3, rank_result1.size
   		assert rank_result1.include?(@ryan)
   		assert rank_result1.include?(@john)
   		assert rank_result1.include?(@matt)
   		deny rank_result1.include?(@alex)
   		deny rank_result1.include?(@mike)
   		rank_result2 = Student.ranks_between(7, 11)
   		assert_equal [@alex], rank_result2
   	end

    # current dojo
    should "have a method that returns the student's current dojo" do
      the_dojo = FactoryGirl.create(:dojo)
      the_dojo_student = FactoryGirl.create(:dojo_student, student: @alex, dojo: the_dojo, end_date: nil)
      assert_equal the_dojo, @alex.current_dojo
      assert @ryan.current_dojo.nil?
      the_dojo.destroy
      the_dojo_student.destroy
    end

   	# tests some validations and creation callbacks
   	# reformatted phone
   	should "reformat phone when a new student is created to only include the numbers" do
   		phone_factory1 = FactoryGirl.create(:student, first_name: "Phone", last_name: "Factory", date_of_birth: 15.years.ago.to_date, phone: "555-555-5555")
   		assert_equal "5555555555", phone_factory1.phone
   		phone_factory1.destroy
   		phone_factory2 = FactoryGirl.create(:student, first_name: "Phone", last_name: "Factory", date_of_birth: 10.years.ago.to_date, phone: "555.555.5555")
   		assert_equal "5555555555", phone_factory2.phone
   		phone_factory2.destroy
   		phone_factory3 = FactoryGirl.create(:student, first_name: "Phone", last_name: "Factory", date_of_birth: 10.years.ago.to_date, phone: "(555) 555-5555")
   		assert_equal "5555555555", phone_factory3.phone
   		phone_factory3.destroy
   	end

   	# can't create a student less than 5 years of age
   	should "not allow a student to be created if the student is less than 5 years old" do
   		four = FactoryGirl.build(:student, date_of_birth: 4.years.ago.to_date)
   		deny four.valid?
   		almost5 = FactoryGirl.build(:student, date_of_birth: 5.years.ago.to_date + 1.day)
   		deny almost5.valid?
   		five = FactoryGirl.build(:student, date_of_birth: 5.years.ago.to_date)
   		assert five.valid?
   	end

   	# presence of first name
   	should "not allow a student to be created without a first name" do
   		blank_name = FactoryGirl.build(:student, first_name: "")
   		deny blank_name.valid?
   		nil_name = FactoryGirl.build(:student, first_name: nil)
   		deny nil_name.valid?
   		# to show the only difference is the first name...
   		works = FactoryGirl.build(:student, first_name: "Present")
   		assert works.valid?
   	end

   	# presence of last name
   	should "not allow a student to be created without a last name" do
   		blank_name = FactoryGirl.build(:student, last_name: "")
   		deny blank_name.valid?
   		nil_name = FactoryGirl.build(:student, last_name: nil)
   		deny nil_name.valid?
   		# to show the only difference is the last name...
   		works = FactoryGirl.build(:student, first_name: "Present")
   		assert works.valid?
   	end

   	# presence of DOB
   	should "not allow a student to be created without a date of birth" do
   		blank_DOB = FactoryGirl.build(:student, date_of_birth: "")
   		deny blank_DOB.valid?
   		nil_DOB = FactoryGirl.build(:student, date_of_birth: nil)
   		deny nil_DOB.valid?
   		# to show with a DOB it works, more explicit to show here instead of having to view factories.rb
   		works = FactoryGirl.build(:student, date_of_birth: 10.years.ago.to_date)
   		assert works.valid?
   	end

   	

  end
end
