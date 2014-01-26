class User < ActiveRecord::Base
	# secure passwords pls
	has_secure_password

	# relationships
	belongs_to :student

	validates_uniqueness_of :email, case_sensitive: false, allow_blank: false
	validates_presence_of :password, on: :create
	validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format"
	validates_inclusion_of :active, in: [true, false], message: "must be true or false"
	validates_inclusion_of :role, in: %w[admin member], message: "not recognized by the system"
	# custom validation
	validate :student_is_active_in_system

	# scopes
	scope :alphabetical, -> { joins(:student).order('last_name, first_name') }

	# collections
	ROLES = [["Administrator", :admin], ["Member", :member]]

	# methods
	def role?(authorized_role)
  	return false if role.nil?
  	role.downcase.to_sym == authorized_role
	end

	def is_admin?
  	role == 'admin'
	end

	def is_member?
  	role == 'member'
	end

	# login by email address
	def self.authenticate(email, password)
	  find_by_email(email).try(:authenticate, password)
	end

	private
	# custom validation to make sure the student is valid in the system
	def student_is_active_in_system
		active_student_ids = Student.active.map { |student| student.id }
		unless active_student_ids.include?(self.student_id)
			errors.add(:student, "is not active in the system")
		end
	end

end
