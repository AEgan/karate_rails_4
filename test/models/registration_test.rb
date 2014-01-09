require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  
  # shouldas 
  # relationships 
  should belong_to(:section)
  should belong_to(:student)
  should have_one(:event).through(:section)

  # data
  # presence
  should validate_presence_of(:date)
  should validate_presence_of(:section_id)
  should validate_presence_of(:student_id)
  # numericality
  should validate_numericality_of(:section_id).only_integer
  should validate_numericality_of(:student_id).only_integer

  # format
  # foreign keys
  should allow_value(1).for(:section_id)
  should allow_value(1).for(:student_id)

  should_not allow_value(7.27).for(:student_id)
  should_not allow_value(7.27).for(:section_id)
  should_not allow_value(nil).for(:student_id)
  should_not allow_value(nil).for(:section_id)
  should_not allow_value("").for(:student_id)
  should_not allow_value("").for(:section_id)

  # date
  should allow_value(Date.today).for(:date)
  should allow_value(1.year.ago.to_date).for(:date)
  should allow_value(5.years.ago.to_date).for(:date)

  should_not allow_value(Date.tomorrow).for(:date)
  should_not allow_value(5).for(:date)
  should_not allow_value("hi").for(:date)

  # tests with context
  context "creating context to test" do
  	# set up context
  	setup do
  		# events
  		@breaking = FactoryGirl.create(:event)
  		@forms = FactoryGirl.create(:event, name: "Forms")
  		# sections
  		@low_breaking = FactoryGirl.create(:section, event: @breaking, max_rank: 4, max_age: 10)
  		@high_breaking = FactoryGirl.create(:section, event: @breaking, min_rank: 10, min_age: 18)
  		@full_forms = FactoryGirl.create(:section, event: @forms)
  		# students
  		@alex = FactoryGirl.create(:student)
  		@ryan = FactoryGirl.create(:student, first_name: "Ryan", rank: 2, date_of_birth: 7.years.ago.to_date)
  		@kyle = FactoryGirl.create(:student, first_name: "Kyle", last_name: "Coppola", rank: 7, date_of_birth: 14.years.ago.to_date)
  		# registrations
  		@alex_breaking = FactoryGirl.create(:registration, student: @alex, section: @high_breaking)
  		@ryan_breaking = FactoryGirl.create(:registration, student: @ryan, section: @low_breaking, date: 1.year.ago.to_date)
  		@alex_forms = FactoryGirl.create(:registration, student: @alex, section: @full_forms, date: 4.years.ago.to_date)
  		@ryan_forms = FactoryGirl.create(:registration, student: @ryan, section: @full_forms, date: 3.years.ago.to_date)
  		@kyle_forms = FactoryGirl.create(:registration, student: @kyle, section: @full_forms, date: 2.years.ago.to_date)
  	end
  	# teardown context
  	teardown do
  		@breaking.destroy
  		@forms.destroy
  		@low_breaking.destroy
  		@high_breaking.destroy
  		@full_forms.destroy
  		@alex.destroy
  		@ryan.destroy
  		@kyle.destroy
  		@alex_breaking.destroy
  		@alex_forms.destroy
  		@ryan_breaking.destroy
  		@ryan_forms.destroy
  		@kyle_forms.destroy
  	end

  	# test the factories for testing
  	should "have working factories for testing" do
  		assert_equal @breaking.name, "Breaking"
  		assert_equal @forms.name, "Forms"
  		assert_equal @breaking.id, @low_breaking.event_id
  		assert_equal @breaking.id, @high_breaking.event_id
  		assert_equal @forms.id, @full_forms.event_id
  		assert_equal @alex.first_name, "Alex"
  		assert_equal @ryan.first_name, "Ryan"
  		assert_equal @kyle.first_name, "Kyle"
  		assert_equal @alex.id, @alex_breaking.student_id
  		assert_equal @ryan.id, @ryan_breaking.student_id
  		assert_equal @alex.id, @alex_forms.student_id
  		assert_equal @ryan.id, @ryan_forms.student_id
  		assert_equal @kyle.id, @kyle_forms.student_id
  	end

  	# scopes
  	# for student
  	should "have a scope to return registrations for a given student" do
  		alex_results = Registration.for_student(@alex.id)
  		assert_equal 2, alex_results.size
  		assert alex_results.include?(@alex_breaking)
  		assert alex_results.include?(@alex_forms)
  		ryan_results = Registration.for_student(@ryan.id)
  		assert_equal 2, ryan_results.size
  		assert ryan_results.include?(@ryan_breaking)
  		assert ryan_results.include?(@ryan_forms)
  		kyle_results = Registration.for_student(@kyle.id)
  		assert_equal [@kyle_forms], kyle_results
  	end

  	# for section
  	should "have a scope to return registrations for a given section " do
  		high_breaking_results = Registration.for_section(@high_breaking.id)
  		assert_equal [@alex_breaking], high_breaking_results
  		low_breaking_results = Registration.for_section(@low_breaking.id)
  		assert_equal [@ryan_breaking], low_breaking_results
  		full_forms_results = Registration.for_section(@full_forms.id)
  		assert_equal 3, full_forms_results.size
  		assert full_forms_results.include?(@alex_forms)
  		assert full_forms_results.include?(@ryan_forms)
  		assert full_forms_results.include?(@kyle_forms)
  	end

  	# by student
  	should "have a scope to return registrations ordered by student name" do
  		by_student_results = Registration.by_student
  		assert_equal [@kyle.id, @alex.id, @alex.id, @ryan.id, @ryan.id], by_student_results.map { |registration| registration.student_id }
  	end

  	# by date
  	should "have a scope to order registrations by date" do
  		by_date_results = Registration.by_date
  		assert_equal [@alex_forms.date, @ryan_forms.date, @kyle_forms.date, @ryan_breaking.date, @alex_breaking.date], by_date_results.map { |r| r.date }
  	end

  	# by event name
  	should "have a scope to order registrations by event name " do
  		by_event_results = Registration.by_event_name
  		assert_equal [@breaking.id, @breaking.id, @forms.id, @forms.id, @forms.id], by_event_results.map { |r| r.section.event_id }
  	end

  end
end
