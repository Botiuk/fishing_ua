class CatchRatesController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    before_action :set_catch_rate, only: %i[ edit update destroy ]
    before_action :water_bioresources_formhelper, only: %i[ new create ]
    authorize_resource

    def index
        if params[:where_catch].present?
            @pagy, @where_catch_rates = pagy(CatchRate.includes(:water_bioresource).where(where_catch: params[:where_catch]).ordered, items: 10)
            @where_catch = params[:where_catch]
        else
            @pagy, @catch_rates = pagy(CatchRate.includes(:water_bioresource).ordered, items: 10)
        end
    rescue Pagy::OverflowError
        redirect_to catch_rates_url(page: 1)
    end

    def new
        @catch_rate = CatchRate.new
    end

    def create
        @catch_rate = CatchRate.new(catch_rate_params)
        if @catch_rate.save
            redirect_to catch_rates_url, notice: t('notice.create.catch_rate')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @where_catch = @catch_rate.where_catch
    end

    def update
        if @catch_rate.update(catch_rate_params)
            redirect_to catch_rates_url, notice: t('notice.update.catch_rate')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @catch_rate.destroy
        redirect_to catch_rates_url, notice: t('notice.destroy.catch_rate')
    end

    private

    def set_catch_rate
        @catch_rate = CatchRate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def water_bioresources_formhelper
        @water_bioresources = WaterBioresource.order(:name).pluck(:name, :id)
    end

    def catch_rate_params
        params.require(:catch_rate).permit(:water_bioresource_id, :where_catch, :length)
    end
end
