class Registration < ActiveRecord::Base

	# relationships 
	belongs_to :section
	belongs_to :student
	has_one :event, through: :section

	# validations
	validates_presence_of :section_id, :student_id, :date
	validates_numericality_of :section_id, allow_blank: false, only_integer: true, greater_than_or_equal_to: 1
	validates_numericality_of :student_id, allow_blank: false, only_integer: true, greater_than_or_equal_to: 1
	validates_date :date, on_or_before: Date.today
	validate :student_active_in_system
	validate :section_active_in_system
	validate :student_rank_valid
	validate :student_age_valid
	validate :unique_registration

	# scopes
	scope :for_student, ->(sid) { where('student_id = ?', sid) }
	scope :for_section, ->(sid) { where('section_id = ?', sid) }
	scope :by_student, -> { joins(:student).order('last_name, first_name') }
	scope :by_date, -> { order('date') }
	scope :by_event_name, -> { joins(:section, :event).order('events.name') }

	# custom validations
	private
	# checks that the student is active
	def student_active_in_system
		active_student_ids = Student.active.map { |student| student.id }
		unless active_student_ids.include?(self.student_id)
			errors.add(:student, " is not active in the system")
		end
	end

	# checks that the section is active
	def section_active_in_system
		active_section_ids = Section.active.map { |section| section.id }
		unless active_section_ids.include?(self.section_id)
			errors.add(:section, " is not active in the system")
		end
	end
# checks that the student rank is in the right range
	def student_rank_valid
		return true if self.student_id.nil? || self.section_id.nil?
		student_rank = self.student.rank
		min_rank = self.section.min_rank
		max_rank = self.section.max_rank
		unless min_rank <= student_rank && (max_rank.nil? || student_rank <= max_rank)
			errors.add(:student_id, " is not in the appropriate rank range")
		end
	end

	# checks that the student age is in the right range
	def student_age_valid
		return true if self.student_id.nil? || self.section_id.nil?
		student_age = self.student.age
		min_age = self.section.min_age
		max_age = self.section.max_age
		unless min_age <= student_age && (max_age.nil? || student_age <= max_age)
			errors.add(:section_id, " is not in the appropriate age range")
		end
	end

	# checks that the student is not already registered for the section
	def unique_registration
		return true if self.student_id.nil? || self.section_id.nil?
		possible_repeat = Registration.where(section_id: self.section_id, student_id: self.student_id)
		unless possible_repeat.empty?
			errors.add(:registration, "is already registered for this section")
			return false
		end
	end
end
