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

    # custom validations
    # event active in system
    should "not allow a section to be created if its associated event is not active " do
      # let's make an inactive event here
      inactive_event = FactoryGirl.create(:event, name: "Sparring", active: false)
      bad_section = FactoryGirl.build(:section, min_age: 10, min_rank: 2, event: inactive_event, max_age: 12, max_rank: 4)
      deny bad_section.valid?
      # we're done with the event so let's destroy it
      inactive_event.destroy
    end

    # repeat based on event, min age, and min rank
    should "not allow a section to be a duplicate of another based on event, minimum age and minimum rank" do
      # complete repeat of basic factory
      full_repeat = FactoryGirl.build(:section, event: @breaking)
      deny full_repeat.valid?
      # repeat of specific factory
      old_repeat = FactoryGirl.build(:section, event: @forms, min_age: 15, min_rank: 7)
      deny old_repeat.valid?
      # changing the minimum age should make it valid
      dif_min_age = FactoryGirl.build(:section, event: @forms, min_age: 15, min_rank: 4)
      assert dif_min_age.valid?
      # changing the minimum rank should make it valid
      dif_min_rank = FactoryGirl.build(:section, event: @forms, min_age: 14, min_rank: 7)
      assert dif_min_rank.valid?
    end

    # other validations
    # max rank < min rank
    should "not allow a section to be created if the max rank is smaller than the min rank" do
      invalid = FactoryGirl.build(:section, event: @breaking, min_age: 20, max_age: 25, min_rank: 10, max_rank: 8)
      deny invalid.valid?
      valid = FactoryGirl.build(:section, event: @breaking, min_age: 20, max_age: 25, min_rank: 8, max_rank: 10)
      assert valid.valid?
    end

    # max age < min age
    should "not allow a section to be created if the max age is smaller than the min age" do
      invalid = FactoryGirl.build(:section, event: @breaking, min_age: 25, max_age: 20, min_rank: 8, max_rank: 10)
      deny invalid.valid?
      valid = FactoryGirl.build(:section, event: @breaking, min_age: 20, max_age: 25, min_rank: 8, max_rank: 10)
      assert valid.valid?
    end

    # age >= 5 years
    should "not allow a section to have a min age less than 5" do
      four_years_min = FactoryGirl.build(:section, event: @breaking, min_rank: 2, min_age: 4)
      deny four_years_min.valid?
      four_years_max = FactoryGirl.build(:section, event: @breaking, max_age: 4, min_age: 4, min_rank: 2)
      deny four_years_max.valid?
    end

    # rank >= 0
    should "not allow either rank to be less than or equal to 0" do
      min_rank_zero = FactoryGirl.build(:section, event: @forms, min_rank: 0, min_age: 9)
      deny min_rank_zero.valid?
      max_rank_zero = FactoryGirl.build(:section, event: @forms, max_rank: 0, min_rank: 0, min_age: 9)
      deny max_rank_zero.valid?
      min_rank_negative = FactoryGirl.build(:section, event: @forms, min_rank: -1, min_age: 9)
      deny min_rank_negative.valid?
      max_rank_negative = FactoryGirl.build(:section , event: @forms, max_rank: -1, min_age: 27)
      deny min_rank_negative.valid?
    end

    # rank and age integers
    should "not allow either rank or age be non integers " do
      min_rank_bad = FactoryGirl.build(:section , event: @forms, min_rank: 1.5)
      deny min_rank_bad.valid?
      max_rank_bad = FactoryGirl.build(:section, event: @forms, min_rank: 1, max_rank: 4.5, min_age: 34)
      deny max_rank_bad.valid?
      min_age_bad = FactoryGirl.build(:section , event: @forms, min_age: 6.5)
      deny min_age_bad.valid?
      max_age_bad = FactoryGirl.build(:section, event: @forms, min_age: 7, max_age: 9.5)
      deny max_age_bad.valid?
    end

    # ranks and ages can't be strings
    should "not allow either ranks or ages be strings " do
      min_rank_bad = FactoryGirl.build(:section , event: @forms, min_rank: "a")
      deny min_rank_bad.valid?
      max_rank_bad = FactoryGirl.build(:section, event: @forms, min_rank: 1, max_rank: "a", min_age: 34)
      deny max_rank_bad.valid?
      min_age_bad = FactoryGirl.build(:section , event: @forms, min_age: "a")
      deny min_age_bad.valid?
      max_age_bad = FactoryGirl.build(:section, event: @forms, min_age: 7, max_age: "a")
      deny max_age_bad.valid?
    end

    # min age and min rank have to be present
    should "not allow min rank or age to be blank or nil " do
      blank_min_age = FactoryGirl.build(:section, event: @forms, min_age: "", min_rank: 17)
      blank_min_rank = FactoryGirl.build(:section, event: @forms, min_rank: "", min_age: 8)
      deny blank_min_rank.valid?
      deny blank_min_age.valid?
      nil_min_age = FactoryGirl.build(:section, event: @forms, min_age: nil, min_rank: 17)
      nil_min_rank = FactoryGirl.build(:section, event: @forms, min_rank: nil, min_age: 8)
      deny nil_min_rank.valid?
      deny nil_min_age.valid?
    end

    # event id must be present
    should "not allow event id to be blank or strings" do
      blank_id = FactoryGirl.build(:section, event_id: "")
      nil_id = FactoryGirl.build(:section, event_id: nil)
      string_id = FactoryGirl.build(:section , event_id: "hi")
      deny blank_id.valid?
      deny nil_id.valid?
      deny string_id.valid?
    end
  end
end
