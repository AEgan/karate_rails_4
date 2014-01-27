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
			# students
			@alex = FactoryGirl.create(:student)
			@ryan = FactoryGirl.create(:student, first_name: "Ryan")
			@john = FactoryGirl.create(:student, first_name: "John", last_name: "Oswald", phone: "5551231234")
			# users
			@alex_user = FactoryGirl.create(:user, student: @alex, role: "admin")
			@ryan_user = FactoryGirl.create(:user, student: @ryan, email: "ryan@example.com")
			@john_user = FactoryGirl.create(:user, student: @john, email: "john@example.com")
		end

		# teardown the context
		teardown do
			# students
			@alex.destroy
			@ryan.destroy
			@john.destroy
			# users
			@alex_user.destroy
			@ryan_user.destroy
			@john_user.destroy
		end

		# make sure the factories work
		should "have working factories for testing " do
			assert_equal @alex.first_name, "Alex"
			assert_equal @ryan.first_name, "Ryan"
			assert_equal @john.first_name, "John"
			assert_equal @alex_user.email, "alex@example.com"
			assert_equal @ryan_user.email, "ryan@example.com"
			assert_equal @john_user.email, "john@example.com"
		end

		# tests the alphabetical scope
		should "have a scope to return users in alphabetical order based on the student's name" do
			assert_equal ["Alex", "Ryan", "John"], User.alphabetical.map { |user| user.student.first_name }
		end

		# tests the is admin method
		should "have a method to determine if a user is an admin" do
			assert @alex_user.is_admin?
			deny   @ryan_user.is_admin?
			deny   @john_user.is_admin?
		end 

		# tests the is member method
		should "have a method to determine if a user is a member, not an admin" do
			deny   @alex_user.is_member?
			assert @ryan_user.is_member?
			assert @john_user.is_member?
		end

		# tests the role method
		should "have a method to determine if the user is the passed in role" do
			assert @alex_user.role?(:admin)
			deny   @ryan_user.role?(:admin)
			deny   @john_user.role?(:admin)
			deny   @alex_user.role?(:member)
			assert @ryan_user.role?(:member)
			assert @john_user.role?(:member)
		end

		# tests the authentication method
		should "authenticate a user if the password and email match what is in the system" do
			assert User.authenticate("alex@example.com", "secret")
			# fails with wrong password
			deny User.authenticate("alex@example.com", "notsecret")
			# fails with wrong email
			deny User.authenticate("notalex@example.com", "secret")
		end
	end
end
