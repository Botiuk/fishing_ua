class WaterBioresourcesController < ApplicationController
    before_action :set_water_bioresource, only: %i[ edit update ]
    authorize_resource

    def index
        @pagy, @water_bioresources = pagy(WaterBioresource.all.order(:name), items: 12)
    rescue Pagy::OverflowError
        redirect_to water_bioresources_url(page: 1)
    end

    def new
        @water_bioresource = WaterBioresource.new
    end

    def create
        @water_bioresource = WaterBioresource.new(water_bioresource_params)
        if @water_bioresource.save
            redirect_to water_bioresources_url, notice: t('notice.create.water_bioresource')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @water_bioresource.update(water_bioresource_params)
            redirect_to water_bioresources_url, notice: t('notice.update.water_bioresource')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_water_bioresource
        @water_bioresource = WaterBioresource.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def water_bioresource_params
        params.require(:water_bioresource).permit(:name, :latin_name, :bioresource_photo, :bioresource_description)
    end
end
