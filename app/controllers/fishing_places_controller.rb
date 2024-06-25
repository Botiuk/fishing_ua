class FishingPlacesController < ApplicationController
    before_action :set_fishing_place, only: %i[ edit update statistic ]
    authorize_resource

    def index
        @pagy, @fishing_places = pagy(FishingPlace.where(user_id: current_user.id).order(:name), items: 10)
    rescue Pagy::OverflowError
        redirect_to fishing_places_url(page: 1)
    end

    def new
        @fishing_place = FishingPlace.new
    end

    def create
        @fishing_place = FishingPlace.new(fishing_place_params)
        @fishing_place.user_id = current_user.id
        if @fishing_place.save
            redirect_to fishing_places_url, notice: t('notice.create.fishing_place')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @fishing_place.update(fishing_place_params)
            redirect_to fishing_places_url, notice: t('notice.update.fishing_place')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def statistic
        @pagy,  @catches = pagy(Catch.includes(:water_bioresource).statistic_all_records(current_user.id, "fishing_place", @fishing_place.id), items: 10)
        if @catches.present?
            @catches_max_weight = Catch.statistic_max_weight(current_user.id, "fishing_place", @fishing_place.id)
            @catches_max_length = Catch.statistic_max_length(current_user.id, "fishing_place", @fishing_place.id)
            @water_bioresources = WaterBioresource.statistic_all_records(current_user.id, "fishing_place", @fishing_place.id)

            @equipments = Tool.statistic_all_tool_type_records(current_user.id, "fishing_place", @fishing_place.id, "equipment")
            @baits = Tool.statistic_all_tool_type_records(current_user.id, "fishing_place", @fishing_place.id, "bait")
        end
    rescue Pagy::OverflowError
        redirect_to water_bioresources_statistic_url(id: @water_bioresource.id, page: 1)
    end

    private

    def set_fishing_place
        @fishing_place = FishingPlace.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def fishing_place_params
        params.require(:fishing_place).permit(:name, :description, :where_catch, :user_id)
    end
end
