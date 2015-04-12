class Doctor < User
  has_many :shifts

	@@NAME = "Doctor"
	def self.NAME; @@NAME; end
end
