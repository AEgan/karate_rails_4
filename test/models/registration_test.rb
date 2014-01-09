require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  
  # shouldas 
  # relationships 
  should belong_to(:section)
  should belong_to(:student)
  should have_one(:event).through(:section)
end
