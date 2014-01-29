require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  
  # relationships
  should have_many(:sections)
  should have_many(:registrations).through(:sections)
  should have_many(:students).through(:registrations)
end
