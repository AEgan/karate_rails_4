class DojoStudent < ActiveRecord::Base

	# relationships
	belongs_to :student
	belongs_to :dojo

	# validations
	validates_presence_of :student_id, :dojo_id, :start_date
	validates_numericality_of :student_id, only_integer: true, allow_blank: false, greater_than: 0
	validates_numericality_of :dojo_id, only_integer: true, allow_blank: false, greater_than: 0
	validates_date :start_date, on_or_before: Date.today, allow_blank: false
	validates_date :end_date, after: :start_date, on_or_before: Date.today, allow_blank: true
	# custom validations
	validate :dojo_is_active_in_system
	validate :student_is_active_in_system

	# scopes
	scope :current, -> { where('end_date IS NULL') }
	scope :by_dojo, -> { joins(:dojo).order('name') }
	scope :by_student, -> { joins(:student).order('last_name, first_name') }
	scope :chronological, -> { order('start_date DESC, end_date DESC') }
	scope :for_student, ->(sID) { where('student_id = ?', sID) }
	scope :by_dojo, ->(dID) { where('dojo_id = ?', dID) }

	private
	# custom validation to make sure the dojo is active in the system
	def dojo_is_active_in_system
		active_dojo_ids = Dojo.active.map { |dojo| dojo.id }

		unless active_dojo_ids.include?(self.dojo_id)
			errors.add(:dojo, " is not active in the system")
		end
	end

	# cutom validation to make sure the student is active in the system
	def student_is_active_in_system
		active_student_ids = Student.active.map { |student| student.id }
		unless active_student_ids.include?(self.student_id)
			errors.add(:student, "is not active in the system")
		end
	end

end
