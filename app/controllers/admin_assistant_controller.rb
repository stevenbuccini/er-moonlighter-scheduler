class AdminAssistantController < AdminsController

	def set_admin
      @admin = AdminAssistant.find(params[:id])
      #needs to redirect if fails
    end
end
