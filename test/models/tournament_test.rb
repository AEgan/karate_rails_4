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
  should_not allow_value(1.day.ago.to_date).for(:date)
  # active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)
end
