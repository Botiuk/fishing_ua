class ToolsController < ApplicationController
    before_action :set_tool, only: %i[ edit update destroy]
    authorize_resource

    def index
        @pagy, @tools = pagy(Tool.where(user_id: current_user.id).order(:name), items: 10)
    rescue Pagy::OverflowError
        redirect_to tools_url(page: 1)
    end

    def new
        @tool = Tool.new
    end

    def create
        @tool = Tool.new(tool_params)
        @tool.user_id = current_user.id
        if @tool.save
            redirect_to tools_url, notice: t('notice.create.tool')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @tool.update(tool_params)
            redirect_to tools_url, notice: t('notice.update.tool')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @tool.destroy
        redirect_to tools_url, notice: t('notice.destroy.tool')
    end

    private

    def set_tool
        @tool = Tool.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def tool_params
        params.require(:tool).permit(:name, :description, :user_id)
    end
end
