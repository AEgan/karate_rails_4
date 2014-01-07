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

end
