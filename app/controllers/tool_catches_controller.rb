class ToolCatchesController < ApplicationController
    before_action :set_tool_catch, only: :destroy
    before_action :tool_formhelpers, only: %i[ new create ]
    authorize_resource

    def new
        if params[:catch_id].present? && params[:tool_type].present?
            @catch = Catch.find(params[:catch_id])
            @tool_catch = ToolCatch.new(catch_id: params[:catch_id])
            @tool_type = params[:tool_type]
        else
            redirect_to catches_url
        end
    end

    def create
        @tool_catch = ToolCatch.new(tool_catch_params)
        @catch = Catch.find(@tool_catch.catch_id)
        if @tool_catch.save
            if @tool_catch.tool.tool_type == "equipment"
                redirect_to catch_url(@catch), notice: t('notice.create.tool_catch.equipment')
            else
                redirect_to catch_url(@catch), notice: t('notice.create.tool_catch.bait')
            end
        else
            if params[:tool_type] == "equipment"
                redirect_to catch_url(@catch), alert: t('alert.create.tool_catch.equipment')
            else
                redirect_to catch_url(@catch), alert: t('alert.create.tool_catch.bait')
            end
        end
    end

    def destroy
        catch = Catch.find(@tool_catch.catch_id)
        tool_type = @tool_catch.tool.tool_type
        @tool_catch.destroy
        if tool_type == "equipment"
            redirect_to catch_url(catch), notice: t('notice.destroy.tool_catch.equipment')
        else
            redirect_to catch_url(catch), notice: t('notice.destroy.tool_catch.bait')
        end
    end

    private

    def set_tool_catch
        @tool_catch = ToolCatch.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def tool_formhelpers
        @tool_equipments = Tool.where(tool_type: "equipment").pluck(:name, :id)
        @tool_baits = Tool.where(tool_type: "bait").pluck(:name, :id)
    end

    def tool_catch_params
        params.require(:tool_catch).permit(:catch_id, :tool_id)
    end
end
