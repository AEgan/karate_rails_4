require 'test_helper'

class DojoStudentTest < ActiveSupport::TestCase
  # relationships
  should belong_to(:student)
  should belong_to(:dojo)
end
