class Users::RegistrationsController < Devise::RegistrationsController

  def build_resource(hash={})
  	# Force all signups to be doctors
  	hash[:type] = 'Doctor'
  	super(hash)
  end
end
