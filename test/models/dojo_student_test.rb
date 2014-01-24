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

end
