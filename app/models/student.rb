class Student < ActiveRecord::Base
	before_save :reformat_phone

	# relationships
	# later when other stuff is here

	# validations
	validates_presence_of :first_name, :last_name, :date_of_birth
	validates_numericality_of :rank, only_integer: true, greater_than_or_equal_to: 1, allow_blank: false
	validates_date :date_of_birth, on_or_before: 5.years.ago.to_date
	validates_format_of :phone, allow_blank: true, with: /^(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
	validates_inclusion_of :active, in: [true, false]

	# scopes
	scope :alphabetical, order('last_name, first_name')
	scope :active, where('active = ?', true)
	scope :inactive, where('active = ?', false)
	scope :has_waiver, where('waiver_signed = ?', true)
	scope :needs_waiver, where('waiver_signed = ?', false)
	scope :dans, where('rank >= 10')
	scope :gups, where('rank < 10')
	scope :juniors, where('date_of_birth > ?', Date.today - 18.years)
	scope :seniors, where('date_of_birth <= ?', Date.today - 18.years)
	scope :by_rank, order('rank DESC')
	scope :ranks_between, lambda {|low, high| where('rank BETWEEN ? AND ?', low, high)}
	scope :ages_between, lambda {|low, high| where('? <= date_of_birth AND date_of_birth <= ?', (high + 1).years.ago.to_date +1.day, low.years.ago.to_date)}


	# methods
	# name in last, first format, eg Smith, John
	def name
		"#{self.last_name}, #{self.first_name}"
	end

	# name if first last format, eg John Smith
	def proper_name
		"#{self.first_name} #{self.last_name}"
	end

	# is this student over 18?
	def over_18?
		self.date_of_birth >= Date.today - 18.years
	end

	# Returns the student's age
  def age
    now = Time.now.utc.to_date
    year = now.year - date_of_birth.year

    unless (now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day))
      year -= 1
    end
    return year
  end

  private
     # We need to strip non-digits before saving to db
     def reformat_phone
       phone = self.phone.to_s   
       phone.gsub!(/[^0-9]/,"") 
       self.phone = phone       
     end
end
