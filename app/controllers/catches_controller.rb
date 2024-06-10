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
        @catch = Catch.new(catch_params)
        if @catch.catch_result == "pick_up" && @catch.water_bioresource.present?
            @rate_length = CatchRate.rate_length(@catch.water_bioresource.id, @catch.fishing_place.where_catch)
            if @rate_length.present?
                if @catch.catch_length >= @rate_length
                    all_day_weight = Catch.all_day_catch_weight(@catch.fishing_session.id)
                    if all_day_weight.present?
                        maximum_weight = Catch.maximum_day_catch(@catch.fishing_session.id)
                        if (@catch.catch_weight > maximum_weight && all_day_weight <= 3) || (@catch.catch_weight.to_s.to_f <= maximum_weight && (all_day_weight - maximum_weight + @catch.catch_weight) <= 3)
                            if @catch.save
                                redirect_to catch_url(@catch), notice: t('notice.create.catch_pick')
                            else
                                render :new, status: :unprocessable_entity
                            end
                        else
                            flash.now[:alert] = t('alert.create.catch.day_weight')
                            render :new, status: :unprocessable_entity
                        end
                    else
                        if @catch.save
                            redirect_to catch_url(@catch), notice: t('notice.create.catch_pick')
                        else
                            render :new, status: :unprocessable_entity
                        end
                    end
                else
                    flash.now[:alert] = t('alert.create.catch.length_rate') + "#{@rate_length}" + t('alert.create.catch.length')
                    render :new, status: :unprocessable_entity
                end
            else
                flash.now[:alert] =  t('alert.create.catch.forbiden')
                render :new, status: :unprocessable_entity
            end
        else
            if @catch.save
                redirect_to catch_url(@catch), notice: t('notice.create.catch_free')
            else
                render :new, status: :unprocessable_entity
            end
        end
    end

    def show
    end

    def edit
        if @catch.fishing_session.end_at.present?
            redirect_to catch_url(@catch), alert: t('alert.fishing_session_close')
        end
        @catch_edit = "yes"
    end

    def update
        if @catch.update(catch_params)
            redirect_to catch_url(@catch), notice: t('notice.update.catch')
        else
            render :edit, status: :unprocessable_entity
        end
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
