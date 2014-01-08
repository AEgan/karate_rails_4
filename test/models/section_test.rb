require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # validations
  # relationships
  should belong_to(:event)

  # presence
  should validate_presence_of(:event_id)
  should validate_presence_of(:min_age)
  should validate_presence_of(:min_rank)

  # numericality
  should validate_numericality_of(:event_id).only_integer
  should validate_numericality_of(:min_age).only_integer
  should validate_numericality_of(:max_age).only_integer
  should validate_numericality_of(:min_rank).only_integer
  should validate_numericality_of(:max_rank).only_integer

  # allow value for active. The rest will be tested with context
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)

  # context
  context "creating context for testing sections" do
  	# set it up
  	setup do
  		# events
  		@breaking = FactoryGirl.create(:event)
  		@forms = FactoryGirl.create(:event, name: "Forms")
  		# sections
  		@full_breaking = FactoryGirl.create(:section, event: @breaking)
  		@full_forms = FactoryGirl.create(:section, event: @forms)
  		@low_breaking = FactoryGirl.create(:section, event: @breaking, min_rank: 2, max_rank: 3, min_age: 6, max_age: 8)
  		@mid_forms = FactoryGirl.create(:section, event: @forms, min_age: 12, max_age: 15, min_rank: 7, max_rank: 9)
  		@high_breaking = FactoryGirl.create(:section, event: @breaking, min_age: 18, max_age: 24, min_rank: 12, max_rank: 15, active: false)
  		@old_forms = FactoryGirl.create(:section, event: @forms, min_rank: 7, min_age: 15, active: false)
  	end

  	# teard it down
  	teardown do
  		# events
  		@breaking.destroy
  		@forms.destroy
  		# sections
  		@full_breaking.destroy
  		@full_forms.destroy
  		@low_breaking.destroy
  		@mid_forms.destroy
  		@high_breaking.destroy
  		@old_forms.destroy
  	end

  	# tests that the factories were created properly
  	should "have working factories for tests" do
  		# events
  		assert_equal "Breaking", @breaking.name
  		assert_equal "Forms", @forms.name
  		# sections
  		assert_equal @breaking.id, @full_breaking.event_id
  		assert_equal @forms.id, @full_forms.event_id
  		assert_equal @breaking.id, @low_breaking.event_id
  		assert_equal @forms.id, @mid_forms.event_id
  		assert_equal @breaking.id, @high_breaking.event_id
  		assert_equal @forms.id, @old_forms.event_id
  	end

  	# scopes
  	# alphabetical
  	should "have a scope that selects sections in alphabetical order then by rank and age" do
  		alphabetical = Section.alphabetical
  		assert_equal [@full_breaking.id, @low_breaking.id, @high_breaking.id, @full_forms.id, @mid_forms.id, @old_forms.id], alphabetical.map { |sect| sect.id }
  	end

  	# for event
  	should "have a scope that gets sections for a given event" do
  		forms_sections = Section.for_event(@forms.id)
  		breaking_sections = Section.for_event(@breaking.id)
  		assert_equal 3, breaking_sections.size
  		assert_equal 3, forms_sections.size
  		assert forms_sections.include?(@full_forms)
  		assert forms_sections.include?(@mid_forms)
  		assert forms_sections.include?(@old_forms)
  		assert breaking_sections.include?(@full_breaking)
  		assert breaking_sections.include?(@low_breaking)
  		assert breaking_sections.include?(@high_breaking)
  	end

  	# active
  	should "have a scope to return active sections" do
  		active_sections = Section.active
  		assert_equal 4, active_sections.size
  		assert active_sections.include?(@full_breaking)
  		assert active_sections.include?(@full_forms)
  		assert active_sections.include?(@low_breaking)
  		assert active_sections.include?(@mid_forms)
  		deny   active_sections.include?(@high_breaking)
  		deny   active_sections.include?(@old_forms)
  	end

  	# inactive
  	should "have a scope to return inactive sections" do
			inactive_sections = Section.inactive
  		assert_equal 2, inactive_sections.size
  		assert inactive_sections.include?(@high_breaking)
  		assert inactive_sections.include?(@old_forms)
  		deny   inactive_sections.include?(@full_breaking)
  		deny   inactive_sections.include?(@full_forms)
  		deny   inactive_sections.include?(@low_breaking)
  		deny   inactive_sections.include?(@mid_forms)
  	end

  	# for rank
  	should "have a scope to return records for a given rank" do
  		rank_4_sections = Section.for_rank(4)
  		assert_equal 2, rank_4_sections.size
  		assert rank_4_sections.include?(@full_breaking)
  		assert rank_4_sections.include?(@full_forms)
  		rank_12_sections = Section.for_rank(12)
  		assert_equal 4, rank_12_sections.size
  		assert rank_12_sections.include?(@full_forms)
  		assert rank_12_sections.include?(@full_breaking)
  		assert rank_12_sections.include?(@old_forms)
  		assert rank_12_sections.include?(@high_breaking)
  	end

  	# for age
  	should "have a scope to return records for a given age" do
  		age_5_sections = Section.for_age(5)
  		assert_equal 2, age_5_sections.size
  		assert age_5_sections.include?(@full_forms)
  		assert age_5_sections.include?(@full_breaking)
  		age_18_sections = Section.for_age(18)
  		assert_equal 4, age_18_sections.size
  		assert age_18_sections.include?(@full_breaking)
  		assert age_18_sections.include?(@full_forms)
  		assert age_18_sections.include?(@high_breaking)
  		assert age_18_sections.include?(@old_forms)
  	end
  end
end
