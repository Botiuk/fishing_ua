class RatePenaltiesController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    before_action :set_rate_penalty, only: %i[ edit update destroy ]
    before_action :water_bioresources_formhelper, only: %i[ new create edit ]
    authorize_resource

    def index
        @pagy, @rate_penalties = pagy(RatePenalty.joins(:water_bioresource).order('water_bioresources.name'), items: 10)
    rescue Pagy::OverflowError
        redirect_to rate_penalties_url(page: 1)
    end

    def new
        @rate_penalty = RatePenalty.new
    end

    def create
        @rate_penalty = RatePenalty.new(rate_penalty_params)
        if @rate_penalty.save
            redirect_to rate_penalties_url, notice: t('notice.create.rate_penalty')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @water_bioresources += WaterBioresource.where(id: @rate_penalty.water_bioresource.id).pluck(:name, :id)
    end

    def update
        if @rate_penalty.update(rate_penalty_params)
            redirect_to rate_penalties_url, notice: t('notice.update.rate_penalty')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @rate_penalty.destroy
        redirect_to rate_penalties_url, notice: t('notice.destroy.rate_penalty')
    end

    private

    def set_rate_penalty
        @rate_penalty = RatePenalty.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def water_bioresources_formhelper
        water_bioresources_with_penalty_ids = RatePenalty.pluck(:water_bioresource_id)
        @water_bioresources = WaterBioresource.where.not(id: water_bioresources_with_penalty_ids).order(:name).pluck(:name, :id)
    end

    def rate_penalty_params
        params.require(:rate_penalty).permit(:water_bioresource_id, :money)
    end
end
