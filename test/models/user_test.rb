require 'test_helper'

class UserTest < ActiveSupport::TestCase

	# relationships
	should belong_to(:student)

	# should validate_uniqueness_of(:email).case_insensitive
	# should validate_numericality_of(:student_id).only_integer

	# shoulda matchers
	# apparently has_secure_password makes shoulda matchers not work in v 2.5.0
	# should allow_value(true).for(:active)
	# should allow_value(false).for(:active)
	# should_not allow_value(nil).for(:active)

	context "creating context to test users" do
		# setup the context
		setup do
			@alex = FactoryGirl.create(:student)
			@alex_user = FactoryGirl.create(:user, student: @alex)
		end

		# teardown the context
		teardown do
			@alex.destroy
			@alex_user.destroy
		end

		# make sure the factories work
		should "have working factories for testing " do
			assert_equal @alex.first_name, "Alex"
			assert_equal @alex_user.email, "alex@example.com"
		end
	end
end
