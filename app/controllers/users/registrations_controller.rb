class Users::RegistrationsController < Devise::RegistrationsController

  def build_resource(hash={})
    # This file was originally here because we were going to override the default registration
    # process for Devise. However, we decided it would be best to leave these users in limbo
    # until they are specifically approved by an admin.
    # However, we were already too far down the rabbit hole in terms of overriding the default
    # Devise behavior and it's highly likely that we'll be overriding this process later in the 
    # project, we're leaving this controller here along with all associated views.
  	super(hash)
  end

end
