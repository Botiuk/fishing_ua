class MainController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    authorize_resource :class => false

    def index
    end

    def statistic
        @fishing_sessions_count = FishingSession.where(user_id: current_user.id).count
        @fishing_sessions_duration = FishingSession.duration_all_sessions(current_user.id) if @fishing_sessions_count != 0
        @fishing_places_count = FishingPlace.where(user_id: current_user.id).count
        @equipments_count = Tool.where(user_id: current_user.id, tool_type: "equipment").count
        @baits_count = Tool.where(user_id: current_user.id, tool_type: "bait").count
        @catches_count = Catch.statistic_all_records(current_user.id, "user", current_user.id)
        if @catches_count != 0
            @catches_max_weight = Catch.statistic_max_weight(current_user.id, "user", current_user.id)
            @catches_max_length = Catch.statistic_max_length(current_user.id, "user", current_user.id)
            @water_bioresources = WaterBioresource.statistic_all_records(current_user.id, "user", current_user.id)
            @fishing_places = FishingPlace.statistic_all_records(current_user.id, "user", current_user.id)
            @equipments = Tool.statistic_all_tool_type_records(current_user.id, "user", current_user.id, "equipment")
            @baits = Tool.statistic_all_tool_type_records(current_user.id, "user", current_user.id, "bait")
        end 
    end
end
