require 'test_helper'

class DojoTest < ActiveSupport::TestCase
  
  # relationships
  should have_many(:dojo_students)
  should have_many(:students).through(:dojo_students)

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

  context "Creating context to test dojos " do
	# set it up
	setup do
		@cmu = FactoryGirl.create(:dojo)
		@sjp = FactoryGirl.create(:dojo, name: "SJP", street: "1733 West Girard Ave", state: "PA", city: "Philadelphia", zip: "12345")
		@nsa = FactoryGirl.create(:dojo, name: "NSA", street: "555 Secret Lane", state: "MD", city: "Someville", zip: "11111", active: false)
	end

	# tear it down
	teardown do
		@cmu.destroy
		@sjp.destroy
		@nsa.destroy
	end 

	# tests that factories are working correctly
	should "have working factories for testing" do
		assert_equal "CMU", @cmu.name
		assert_equal "SJP", @sjp.name
		assert_equal "NSA", @nsa.name
	end

	# scopes
	# alphabetical
	should "have a scope to order dojos alphabetically" do
		assert_equal ["CMU", "NSA", "SJP"], Dojo.alphabetical.map { |dojo| dojo.name }
	end

	# active
	should "have a scope to return only active dojos" do
		active_results = Dojo.active
		assert_equal 2, active_results.size
		assert active_results.include?(@cmu)
		assert active_results.include?(@sjp)
		deny active_results.include?(@nsa)
	end

	# inactive
	should "have a scope to return only inactive dojos" do
		assert_equal [@nsa.name], Dojo.inactive.map { |dojo| dojo.name }
	end

  end




end
