class Dojo < ActiveRecord::Base
	# relationships
	has_many :dojo_students
	has_many :students, through: :dojo_students

	# Lists
  	STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]

	# validations
	validates_presence_of :name, :street, :city
	validates_uniqueness_of :name, case_sensitive: false
	validates_inclusion_of :state, in: STATES_LIST.map { |k, v| v }, message: "is not recognized in the system"
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :active, in: [true, false]

	# scopes
	scope :alphabetical, -> { order('name') }
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }

	# methods
	# def current_students
	#	will be included when relationships are added
	# end
	
end
