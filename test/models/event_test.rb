require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # validations
  # relatiionships
  should have_many(:sections)
  # name
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive
  # active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)

  # testing events with context
  context "creating context" do
  	# set it up
  	setup do
  		@breaking = FactoryGirl.create(:event)
  		@forms    = FactoryGirl.create(:event, name: "Forms")
  		@sparring = FactoryGirl.create(:event, name: "Sparring", active: false)
  	end

  	# tear it down
  	teardown do
  		@breaking.destroy
  		@forms.destroy
  		@sparring.destroy
  	end

  	# tests that the factories were created correctly
  	should "have factories created correctly" do
  		assert_equal "Breaking", @breaking.name
  		assert_equal "Forms", @forms.name
  		assert_equal "Sparring", @sparring.name
  		assert @breaking.active
  		assert @forms.active
  		deny @sparring.active
  	end

  	# scopes
  	# testing the alphabetical scope works as expected
  	should "have a scope to return events in alphabetical order" do
  		result = Event.alphabetical
  		assert_equal 3, result.size
  		assert result.include?(@breaking)
  		assert result.include?(@forms)
  		assert result.include?(@sparring)
  		assert_equal ["Breaking", "Forms", "Sparring"], result.map { |val| val.name }
  	end

  	# testing the active scope
  	should "have a scope to return active events only" do
  		result = Event.active
  		assert_equal 2, result.size
  		assert result.include?(@breaking)
  		assert result.include?(@forms)
  		deny result.include?(@sparring)
  	end

  	# testing the inactive scope
  	should "have a scope to return inactive events only" do
  		result = Event.inactive
  		assert_equal 1, result.size
  		assert result.include?(@sparring)
  		deny result.include?(@forms)
  		deny result.include?(@breaking)
  	end

  	# validations and such
  	# no repeats
  	should "not allow events to be created with the same name as another event" do
  		name_repeat1 = FactoryGirl.build(:event)
  		name_repeat2 = FactoryGirl.build(:event, name: "Forms")
  		name_repeat3 = FactoryGirl.build(:event, name: "Sparring")
  		deny name_repeat1.valid?
  		deny name_repeat2.valid?
  		deny name_repeat3.valid?
  	end

  	# case insensitive names
  	should "not allow names to be identical with different case" do
  		# looks like pro console gamertags here
  		name_repeat1 = FactoryGirl.build(:event, name: "bReAkInG")
  		name_repeat2 = FactoryGirl.build(:event, name: "sPaRrInG")
  		name_repeat3 = FactoryGirl.build(:event, name: "fOrMs")
  		deny name_repeat1.valid?
  		deny name_repeat2.valid?
  		deny name_repeat3.valid?
  	end

  	# no blank names
  	should "not allow events to be created with blank names" do
  		blank_name = FactoryGirl.build(:event, name: "")
  		deny blank_name.valid?
  	end

  	# no nil names
  	should "not allow events to be created with a nil name" do
  		nil_name = FactoryGirl.build(:event, name: nil)
  		deny nil_name.valid?
  	end

  	# no blank actives
  	should "not allow an event with blank active to be created" do
  		blank_active = FactoryGirl.build(:event, name: "different", active: "")
  		deny blank_active.valid?
  	end

  	# no nil actives
  	should "not allow an event with nil active to be created" do
  		nil_active = FactoryGirl.build(:event, name: "different again", active: nil)
  		deny nil_active.valid?
  	end

  end
end
