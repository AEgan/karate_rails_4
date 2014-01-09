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
  	end
  	# teardown context
  	teardown do
  	end
  end
end
