class FishingSessionsController < ApplicationController
    before_action :set_fishing_session, only: %i[ show edit update ]
    before_action :fishing_place_formhelper, only: %i[ new create edit update ]
    authorize_resource

    def index
        @pagy, @fishing_sessions = pagy(FishingSession.where(user_id: current_user.id).order(:start_at, :id).reverse_order, items: 10)
    rescue Pagy::OverflowError
        redirect_to fishing_sessions_url(page: 1)
    end

    def new
        last_fishing_session = FishingSession.where(user_id: current_user.id, end_at: nil).last
        if last_fishing_session.blank?
            @fishing_session = FishingSession.new
        else
            redirect_to fishing_sessions_url, alert: t('alert.new.fishing_session')
        end
    end

    def create
        @fishing_session = FishingSession.new(fishing_session_params)
        @fishing_session.user_id = current_user.id
        if @fishing_session.save
            redirect_to fishing_session_url(@fishing_session), notice: t('notice.create.fishing_session')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @session_catches = Catch.where(fishing_session_id: @fishing_session.id).order(:catch_time, :id).reverse_order
    end

    def edit
        if @fishing_session.end_at.present?
            redirect_to fishing_session_url(@fishing_session), alert: t('alert.fishing_session_close')
        end
    end

    def update
        if @fishing_session.update(fishing_session_params)
            if @fishing_session.end_at.blank?
                redirect_to fishing_session_url(@fishing_session), notice: t('notice.update.fishing_session')
            else
                redirect_to fishing_session_url(@fishing_session), notice: t('notice.update.fishing_session_close')
            end
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_fishing_session
        @fishing_session = FishingSession.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def fishing_place_formhelper
        @fishing_places = FishingPlace.where(user_id: current_user.id).order(:name).pluck(:name, :id)
    end

    def fishing_session_params
        params.require(:fishing_session).permit(:start_at, :end_at, :user_id, :fishing_place_id)
    end
end
