class Section < ActiveRecord::Base

	# relationships
	belongs_to :event
	belongs_to :tournament
	has_many :registrations
	has_many :students, through: :registrations

	# validations
	validate :unique_section
	validate :active_event
	validate :active_tournament
	validates_presence_of :event_id, :min_age, :min_rank
	validates_numericality_of :event_id, only_integer: true, greater_than_or_equal_to: 1
	validates_numericality_of :tournament_id, only_integer: true, greater_than_or_equal_to: 1, allow_blank: false
	validates_numericality_of :min_age, only_integer: true, greater_than_or_equal_to: 5
	validates_numericality_of :min_rank, only_integer: true, greater_than_or_equal_to: 1
	validates_numericality_of :max_age, allow_blank: true, only_integer: true, greater_than_or_equal_to: :min_age
	validates_numericality_of :max_rank, allow_blank: true, only_integer: true, greater_than_or_equal_to: :min_rank
	validates_inclusion_of :active, in: [true, false], message: "Must be true or false"

	# scopes
	scope :for_event, ->(eid) { where('event_id = ?', eid) }
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }
	scope :alphabetical, -> { joins(:event).order("events.name, sections.min_rank, sections.min_age") }
	scope :for_rank, ->(rank) { where("min_rank <= ? AND (max_rank IS NULL OR ? <= max_rank)", rank, rank) }
	scope :for_age, ->(age) { where("min_age <= ? AND (max_age IS NULL OR ? <= max_age)", age, age) }
	scope :by_location, -> { order('location') }
	scope :for_location, ->(loc) { where('location LIKE ?', "%#{loc}%") }
	scope :for_tournament, ->(tid) { where('tournament_id = ?', tid) }
	
	# custom validations
	private

	# determines if the section is unique
	def unique_section
		sections = Section.all
		if sections.size == 0
			return true
		end

		sections.each do |section|
			if(section.event_id == self.event_id && section.min_rank == self.min_rank && section.min_age == self.min_age && section.tournament_id == self.tournament_id)
				errors.add(:section, " is a duplicate section based on the event, minimum rank, and minimum age")
				return false
			end
		end
		true
	end

	# makes sure the event is active
	def active_event
		active_event_ids = Event.active.map { |event| event.id }

		if !active_event_ids.include?(self.event_id)
			errors.add(:section, " the event associated with this section is no longer active in the system")
			return false
		end

		true
	end

	# makes sure tournament is active
	def active_tournament
		active_tournament_ids = Tournament.active.map { |tournament| tournament.id }
		unless active_tournament_ids.include?(self.tournament_id)
			errors.add(:tournament, " the tournament is not active in the system")
			return false
		end
		true
	end

end
