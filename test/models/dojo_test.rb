require 'test_helper'

class DojoTest < ActiveSupport::TestCase
  
  # relationships
  # will be added when dojo_students is added

  # validations
  # presence
  should validate_presence_of :name
  should validate_presence_of :street
  should validate_presence_of :city
  # uniquness
  should validate_uniqueness_of(:name).case_insensitive

  # shoulda matchers
  # zip
  should allow_value("15213").for(:zip)
  should allow_value(15213).for(:zip)
  should_not allow_value("bad").for(:zip)
  should_not allow_value("1512").for(:zip)
  should_not allow_value("152134").for(:zip)
  should_not allow_value("15213-0983").for(:zip)
  # tests for state
  should allow_value("OH").for(:state)
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should_not allow_value("bad").for(:state)
  should allow_value("NY").for(:state)
  should_not allow_value(10).for(:state)
  should allow_value("CA").for(:state)
  # active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)




end
