require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  
  # relationships
  should have_many(:sections)
  should have_many(:registrations).through(:sections)
  should have_many(:students).through(:registrations)

  # validations
  # name
  should validate_presence_of(:name)
  # min rank
  should validate_numericality_of(:min_rank)
  should allow_value(1).for(:min_rank)
  should allow_value(7).for(:min_rank)
  should allow_value(10).for(:min_rank)
  should allow_value(12).for(:min_rank)
  should_not allow_value(0).for(:min_rank)
  should_not allow_value(-1).for(:min_rank)
  should_not allow_value(3.14159).for(:min_rank)
  should_not allow_value(nil).for(:min_rank)
  # max rank (without context, so limited)
  should validate_numericality_of(:max_rank)
  should allow_value(nil).for(:max_rank)
  # date
  should allow_value(Date.today).for(:date)
  should allow_value(1.day.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(2).for(:date)
  should_not allow_value(3.14159).for(:date)
  should_not allow_value(Date.today - 1.day).for(:date)
  # active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)

  context "creating context for testing tournaments" do
  	# setting up context
  	setup do
  		@grand_finals = FactoryGirl.create(:tournament)
  		@dans = FactoryGirl.create(:tournament, name: "Dans", date: 5.weeks.from_now.to_date, min_rank: 11, max_rank: nil)
  		@gups = FactoryGirl.create(:tournament, name: "Gups", date: 4.weeks.from_now.to_date, min_rank: 1, max_rank: 10)
  		@inactive = FactoryGirl.create(:tournament, name: "Inactive", date: Date.current, active: false)
  	end
  	# teardown context
  	teardown do
  		@grand_finals.destroy
  		@dans.destroy
  		@gups.destroy
  		@inactive.destroy
  	end

  	# tests the tests for tests tests tests
  	should "have working factories for testing" do
  		assert_equal @grand_finals.name, "Grand Finals"
  		assert_equal @dans.name, "Dans"
  		assert_equal @gups.name, "Gups"
  		assert_equal @inactive.name, "Inactive"
  	end

  	# scopes
  	# alphabetical
  	should "have an alphabetical scope" do
  		assert_equal ["Dans", "Grand Finals", "Gups", "Inactive"], Tournament.alphabetical.map { |tournament| tournament.name }
  	end

  	# chronological
  	should "have a chronological scope" do
  		assert_equal ["Inactive", "Grand Finals", "Gups", "Dans"], Tournament.chronological.map { |tournament| tournament.name }
  	end

  	# active
  	should "have a scope to return active tournaments" do
  		active_tournaments = Tournament.active
  		assert_equal active_tournaments.size, 3
  		assert active_tournaments.include?(@grand_finals)
  		assert active_tournaments.include?(@dans)
  		assert active_tournaments.include?(@gups)
  		deny   active_tournaments.include?(@inactive)
  	end

  	# inactive
  	should "have a scope to return inactive tournaments " do
  		inactive_tournaments = Tournament.inactive
  		assert_equal inactive_tournaments.size, 1
  		deny   inactive_tournaments.include?(@grand_finals)
  		deny   inactive_tournaments.include?(@dans)
  		deny   inactive_tournaments.include?(@gups)
  		assert inactive_tournaments.include?(@inactive)
  	end

  	# past
  	should "have a scope to return past tournaments" do
  		# making one in the past b/c doesn't work on create
  		@inactive.date = 1.week.ago.to_date
  		@inactive.save
  		assert_equal 1, Tournament.past.size
  	end

  	# upcoming
  	should "have a scope to return upcoming tournaments" do
  		# inactive was destroyed and remade in the future, so
  		assert_equal 4, Tournament.upcoming.size
  	end

  	# next
  	should "have a scope to return x number of tournaments, x being a param" do
  		assert_equal 1, Tournament.next(1).size
  		assert_equal 2, Tournament.next(2).size
  		assert_equal 3, Tournament.next(3).size
  		assert_equal 4, Tournament.next(4).size
  	end
  end
end
