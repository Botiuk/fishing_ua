class CatchesController < ApplicationController
    before_action :set_catch, only: %i[ show edit update ]
    before_action :water_bioresources_formhelper, only: %i[ new create edit update ]
    authorize_resource

    def index
        @pagy, @catches = pagy(Catch.joins(:fishing_place).where(fishing_place: {user_id: current_user.id}).order(:catch_time, :id).reverse_order, items: 10)
    rescue Pagy::OverflowError
        redirect_to catches_url(page: 1)
    end

    def new
        if params[:fishing_session_id].present?
            active_session = FishingSession.find(params[:fishing_session_id])
            if active_session.end_at.blank?
                @catch = Catch.new(fishing_session_id: params[:fishing_session_id])
            else
                redirect_to fishing_session_url(active_session), alert: t('alert.fishing_session_close')
            end
        else
            active_session = FishingSession.where(user_id: current_user.id, end_at: nil).last
            if active_session.present?
                @catch = Catch.new(fishing_session_id: active_session.id)
            else
                redirect_to new_fishing_session_url, alert: t('alert.new.session_catch')
            end
        end
    end

    def create
        
    end

    def show
    end

    def edit
        
    end

    def update
        
    end

    private

    def set_catch
        @catch = Catch.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def water_bioresources_formhelper
        @water_bioresources = WaterBioresource.order(:name).pluck(:name, :id)
    end

    def catch_params
        params.require(:catch).permit(:catch_time, :catch_length, :catch_weight, :catch_result, :fishing_session_id, :water_bioresource_id, catch_photos: [] )
    end
end
