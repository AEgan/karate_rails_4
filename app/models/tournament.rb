class Tournament < ActiveRecord::Base
	
	# relatinoships
	has_many :sections
	has_many :registrations, through: :sections
	has_many :students, through: :registrations

	# validations
	validates_presence_of :name
	validates_date :date, on_or_before: Date.today, on_or_before_message: "Date cannot be in the future", on: :create
	validates_numericality_of :min_rank, only_integer: true, greater_than: 0
	validates_numericality_of :max_rank, only_integer: true, greater_than: :min_rank, allow_blank: true
	validates_inclusion_of :active, in: [true, false], message: "Must be true or false"

	# scopes
	scope :alphabetical, -> { order('name') }
	scope :chronological, -> { order('date') }
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }
	scope :past, -> { where('date < ?', Date.today) }
	scope :upcoming, -> { where('date >= ?', Date.today) }
	scope :next, ->(num) { limit(num) }
end
