class MainController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    authorize_resource :class => false

    def index
    end

    def statistic
        @catches_count = Catch.statistic_all_records(current_user.id, "user", current_user.id)
        if @catches_count.present?
            @catches_max_weight = Catch.statistic_max_weight(current_user.id, "user", current_user.id)
            @catches_max_length = Catch.statistic_max_length(current_user.id, "user", current_user.id)
            @water_bioresources = WaterBioresource.statistic_all_records(current_user.id, "user", current_user.id)
            @fishing_places = FishingPlace.statistic_all_records(current_user.id, "user", current_user.id)
            @equipments = Tool.statistic_all_tool_type_records(current_user.id, "user", current_user.id, "equipment")
            @baits = Tool.statistic_all_tool_type_records(current_user.id, "user", current_user.id, "bait")
        end 
    end
end
