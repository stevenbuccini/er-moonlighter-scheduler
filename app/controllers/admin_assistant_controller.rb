class AdminAssistantController < AdminsController

	def set_admin
      @admin = AdminAssistant.find(params[:id])
    end
end
