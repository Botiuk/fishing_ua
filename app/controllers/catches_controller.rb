class CatchesController < ApplicationController
    before_action :set_catch, only: %i[ show update destroy ]
    before_action :water_bioresources_formhelper, only: %i[ new create update ]
    authorize_resource

    def index
        @pagy, @catches = pagy(Catch.includes(:water_bioresource).joins(:fishing_place).where(fishing_place: {user_id: current_user.id}).order(:catch_time, :id).reverse_order, items: 10)
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
            if active_session.present? && params[:water_bioresource_id].present?
                @catch = Catch.new(fishing_session_id: active_session.id, water_bioresource_id: params[:water_bioresource_id])
            elsif active_session.present?
                @catch = Catch.new(fishing_session_id: active_session.id)
            else
                redirect_to new_fishing_session_url, alert: t('alert.new.session_catch')
            end
        end
    end

    def create
        @catch = Catch.new(catch_params)
        if @catch.catch_result == "pick_up" && @catch.water_bioresource.present?
            rate_length = CatchRate.rate_length(@catch.water_bioresource.id, @catch.fishing_place.where_catch)
            if rate_length.present?
                if @catch.catch_length >= rate_length.to_f                  
                    catch_day_rate = DayRate.where(water_bioresource_id: @catch.water_bioresource.id).first
                    if catch_day_rate.present?
                        if catch_day_rate.catch_amount == 0
                            if @catch.save
                                redirect_to catch_url(@catch), notice: t('notice.create.catch_pick')
                            else
                                render :new, status: :unprocessable_entity
                            end
                        else
                            if catch_day_rate.amount_type == "weight"                            
                                if @catch.catch_weight > 0
                                    all_day_one_resource_weight = Catch.all_day_catch_one_resource_weight(@catch.fishing_session.id, @catch.water_bioresource.id)
                                    if all_day_one_resource_weight + @catch.catch_weight <= catch_day_rate.catch_amount
                                        if @catch.save
                                            redirect_to catch_url(@catch), notice: t('notice.create.catch_pick')
                                        else
                                            render :new, status: :unprocessable_entity
                                        end
                                    else
                                        flash.now[:alert] = t('alert.create.catch.day_weight_one_resource') + "#{catch_day_rate.catch_amount}" + t('alert.create.catch.day_weight_now_catch') + "#{all_day_one_resource_weight}"
                                        render :new, status: :unprocessable_entity
                                    end
                                else
                                    flash.now[:alert] = t('alert.create.catch.catch_weight')
                                    render :new, status: :unprocessable_entity
                                end
                            else
                                all_day_one_resource_quantity = Catch.all_day_catch_one_resource_quantity(@catch.fishing_session.id, @catch.water_bioresource.id)
                                if all_day_one_resource_quantity < catch_day_rate.catch_amount
                                    if @catch.save
                                        redirect_to catch_url(@catch), notice: t('notice.create.catch_pick')
                                    else
                                        render :new, status: :unprocessable_entity
                                    end
                                else
                                    flash.now[:alert] = t('alert.create.catch.day_quantity_one_resource') + "#{catch_day_rate.catch_amount.to_i}"
                                    render :new, status: :unprocessable_entity
                                end
                            end
                        end
                    else
                        if @catch.catch_weight > 0
                            day_rate_water_bioresource_ids = DayRate.pluck(:water_bioresource_id)
                            all_day_weight = Catch.all_day_catch_weight(@catch.fishing_session.id, day_rate_water_bioresource_ids)
                            if all_day_weight != 0
                                maximum_weight = Catch.maximum_day_catch(@catch.fishing_session.id, day_rate_water_bioresource_ids)
                                if (@catch.catch_weight >= maximum_weight && all_day_weight <= 3) || (@catch.catch_weight <= maximum_weight && (all_day_weight - maximum_weight + @catch.catch_weight) <= 3)
                                    if @catch.save
                                        redirect_to catch_url(@catch), notice: t('notice.create.catch_pick')
                                    else
                                        render :new, status: :unprocessable_entity
                                    end
                                else
                                    flash.now[:alert] = t('alert.create.catch.day_weight') + t('alert.create.catch.day_weight_now_catch_without_trophy') + "#{(all_day_weight - maximum_weight)}" + t('alert.create.catch.day_weight_now_catch_trophy') + "#{maximum_weight}"
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
                            flash.now[:alert] = t('alert.create.catch.catch_weight')
                            render :new, status: :unprocessable_entity
                        end
                    end
                else
                    flash.now[:alert] = t('alert.create.catch.length_rate') + "#{rate_length}"
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
        @pagy, @tool_catches = pagy(ToolCatch.includes(:tool).where(catch_id: @catch.id).order_by_tool, items: 10)
    rescue Pagy::OverflowError
        redirect_to catch_url(@catch, page: 1)
    end

    def update
        if @catch.update(catch_params)
            redirect_to catch_url(@catch), notice: t('notice.update.catch')
        end
    end

    def destroy
        fishing_session = @catch.fishing_session
        @catch.destroy
        redirect_to fishing_session_url(fishing_session), notice: t('notice.destroy.catch')
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
