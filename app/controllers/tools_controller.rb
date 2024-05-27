class ToolsController < ApplicationController
    before_action :set_tool, only: %i[ edit update destroy]
    authorize_resource

    def index
        if params[:tool_type].present?
            @tool_type = params[:tool_type]
        else            
            @tool_type = "equipment"
        end
        @pagy, @tools = pagy(Tool.where(user_id: current_user.id, tool_type: @tool_type).order(:name), items: 10)
    rescue Pagy::OverflowError
        redirect_to tools_url(page: 1)
    end

    def new
        @tool = Tool.new(tool_type: params[:tool_type])
    end

    def create
        @tool = Tool.new(tool_params)
        @tool.user_id = current_user.id
        if @tool.save
            if @tool.tool_type == "equipment"
                redirect_to tools_url(tool_type: "equipment"), notice: t('notice.create.equipment')
            else
                redirect_to tools_url(tool_type: "bait"), notice: t('notice.create.bait')
            end
        else
            render :new, tool_type: @tool.tool_type, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @tool.update(tool_params)
            if @tool.tool_type == "equipment"
                redirect_to tools_url(tool_type: "equipment"), notice: t('notice.update.equipment')
            else
                redirect_to tools_url(tool_type: "bait"), notice: t('notice.update.bait')
            end
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        tool_type = @tool.tool_type
        @tool.destroy
        if tool_type == "equipment"
            redirect_to tools_url(tool_type: "equipment"), notice: t('notice.destroy.equipment')
        else
            redirect_to tools_url(tool_type: "bait"), notice: t('notice.destroy.bait')
        end
    end

    private

    def set_tool
        @tool = Tool.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def tool_params
        params.require(:tool).permit(:name, :description, :tool_type, :user_id)
    end
end
