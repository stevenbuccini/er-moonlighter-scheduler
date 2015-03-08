class User::RegistrationsController < Devise::RegistrationsController

  def new
    redirect_to "http://google.com"
  end

  # Overwriting the default build_resource because we need to force it
  # to create a new user of type Doctor
  def build_resource(hash=nil)
    hash[:type] = :doctor
    self.resource = resource_class.new_with_session(hash, session)
  end
end
