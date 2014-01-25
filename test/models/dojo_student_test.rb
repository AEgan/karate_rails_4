require 'test_helper'

class DojoStudentTest < ActiveSupport::TestCase
  # relationships
  should belong_to(:student)
  should belong_to(:dojo)

  # validations
  should validate_presence_of(:student_id)
  should validate_presence_of(:dojo_id)
  should validate_numericality_of(:student_id).only_integer
  should validate_numericality_of(:dojo_id).only_integer

  # shoulda matchers
  # ids... note no passing values because of the custom validation for an active student
  should_not allow_value(3.14159).for(:student_id)
  should_not allow_value(0).for(:student_id)
  should_not allow_value(-1).for(:student_id)
  should_not allow_value(3.14159).for(:dojo_id)
  should_not allow_value(0).for(:dojo_id)
  should_not allow_value(-1).for(:dojo_id)
  # start date. no end date because it has to be checked with context to compare with start date
  should allow_value(7.weeks.ago.to_date).for(:start_date)
  should allow_value(1.day.ago.to_date).for(:start_date)
  should allow_value(Date.today).for(:start_date)
  should_not allow_value(1.week.from_now.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(nil).for(:start_date)

  context "creating context to test dojo students" do
  	# set it up
  	setup do
      # students
  		@alex = FactoryGirl.create(:student)
  		@ryan = FactoryGirl.create(:student, first_name: "Ryan", rank: 1, waiver_signed: false, date_of_birth: 22.years.ago.to_date)
      @john = FactoryGirl.create(:student, first_name: "John", last_name: "Oswald", phone: "1234502121")
      # dojos
  		@cmu = FactoryGirl.create(:dojo)
      @sjp = FactoryGirl.create(:dojo, name: "SJP", street: "1733 West Girard Ave", city: "Philadelphia", state: "PA", zip: "19130")
      # dojo_students
  		@alex_cmu = FactoryGirl.create(:dojo_student, student: @alex, dojo: @cmu, start_date: 6.months.ago.to_date)
  		@ryan_cmu = FactoryGirl.create(:dojo_student, student: @ryan, dojo: @cmu)
      @alex_sjp = FactoryGirl.create(:dojo_student, student: @alex, dojo: @sjp, start_date: 2.years.ago.to_date, end_date: 1.year.ago.to_date)
      @ryan_sjp = FactoryGirl.create(:dojo_student, student: @ryan, dojo: @sjp, start_date: 2.years.ago.to_date, end_date: 15.months.ago.to_date)
      @john_sjp = FactoryGirl.create(:dojo_student, student: @john, dojo: @sjp, start_date: 4.years.ago.to_date)
  	end

  	# tear it down
  	teardown do
      # students
  		@alex.destroy
  		@ryan.destroy
      @john.destroy
      # dojos
  		@cmu.destroy
      @sjp.destroy
      # dojo_students
  		@alex_cmu.destroy
  		@ryan_cmu.destroy
      @alex_sjp.destroy
      @ryan_sjp.destroy
      @john_sjp.destroy
  	end

    # make sure factories work
  	should "have working factories for testing" do
      # students
  		assert_equal "Alex", @alex.first_name
  		assert_equal "Ryan", @ryan.first_name
      assert_equal "John", @john.first_name
      # dojos
  		assert_equal "CMU", @cmu.name
      assert_equal "SJP", @sjp.name
      # dojo_students
  		assert_equal 6.months.ago.to_date, @alex_cmu.start_date
  		assert_equal 1.year.ago.to_date, @ryan_cmu.start_date
      assert_equal 1.year.ago.to_date, @alex_sjp.end_date
      assert_equal 15.months.ago.to_date, @ryan_sjp.end_date
      assert_equal 4.years.ago.to_date, @john_sjp.start_date
  	end

    # scopes
    # tests the current scope
    should "have a scope to return the current dojo_student records" do
      records = DojoStudent.current
      assert_equal records.size, 3
      assert records.include?(@alex_cmu)
      assert records.include?(@ryan_cmu)
      assert records.include?(@john_sjp)
      # unnecessary because we assert 3 as the size and assert that it includes each of the three records it should
      # but just to make it a point...
      deny records.include?(@alex_sjp)
      deny records.include?(@ryan_sjp)
    end

    # order by dojo name
    should "have a scope to order dojo_student records by dojo name" do
      records = DojoStudent.by_dojo.map { |ds| ds.dojo.name }
      assert_equal records, ["CMU", "CMU", "SJP", "SJP", "SJP"]
    end

    # order by student name
    should "have a scope to order records by student name " do
      records = DojoStudent.by_student.map { |ds| ds.student.first_name }
      assert_equal records, ["Alex", "Alex", "Ryan", "Ryan", "John"]
    end

    # for student
    should "have a scope to return records for a given student" do
      alex_records = DojoStudent.for_student(@alex.id)
      assert_equal 2, alex_records.size
      assert alex_records.include?(@alex_sjp)
      assert alex_records.include?(@alex_cmu)
      john_records = DojoStudent.for_student(@john.id)
      assert_equal [@john_sjp], john_records
    end

    # for dojo
    should "have a scope to return records for a given dojo" do
      cmu_records = DojoStudent.for_dojo(@cmu.id)
      assert_equal 2, cmu_records.size
      assert cmu_records.include?(@alex_cmu)
      assert cmu_records.include?(@ryan_cmu)
      sjp_records = DojoStudent.for_dojo(@sjp.id)
      assert_equal 3, sjp_records.size
      assert sjp_records.include?(@john_sjp)
      assert sjp_records.include?(@alex_sjp)
      assert sjp_records.include?(@ryan_sjp)
    end

    # chronological
    should "have a scope to order dojo students chronologically by start date then end date" do
      # mapping the IDS so if this results in an error it will be easier to determine what was expected and what we got when looking
      # at the console, only get numbers not everything else
      records = DojoStudent.chronological.map { |ds| ds.id }
      assert_equal [@alex_cmu.id, @ryan_cmu.id, @alex_sjp.id, @ryan_sjp.id, @john_sjp.id], records
    end
  end

end
