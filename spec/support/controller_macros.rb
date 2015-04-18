module ControllerMacros
  
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin, :email => 'master@example.com') # Using factory girl as an example
    end
  end

   def login_admin_return(email)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      user =  FactoryGirl.create(:admin, :email => email) # Using factory girl as an example
      sign_in user 
      return user 
    end
  end


  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
     # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end


  #def doctor_params
  #  params.require(:doctor).permit(:first_name, :last_name, :phone_1, :phone_2, :phone_3)
  #end
end
