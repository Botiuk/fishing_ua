# frozen_string_literal: true

class WaterBioresourcesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_water_bioresource, only: %i[show edit update statistic]
  authorize_resource

  def index
    @pagy, @water_bioresources = pagy(WaterBioresource.order(:name), items: 12)
  rescue Pagy::OverflowError
    redirect_to water_bioresources_url(page: 1)
  end

  def show
    @catch_rate = CatchRate.find_by(water_bioresource_id: @water_bioresource.id)
    @rate_penalty = RatePenalty.find_by(water_bioresource_id: @water_bioresource.id)
  end

  def new
    @water_bioresource = WaterBioresource.new
  end

  def edit; end

  def create
    @water_bioresource = WaterBioresource.new(water_bioresource_params)
    if @water_bioresource.save
      redirect_to water_bioresource_url(@water_bioresource), notice: t('notice.create.water_bioresource')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @water_bioresource.update(water_bioresource_params)
      redirect_to water_bioresource_url(@water_bioresource), notice: t('notice.update.water_bioresource')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def statistic
    @pagy, @catches = pagy(
      Catch.includes(:water_bioresource).statistic_all_records(current_user.id, 'water_bioresource',
                                                               @water_bioresource.id), items: 10
    )
    statistic_with_catch if @catches.present?
  rescue Pagy::OverflowError
    redirect_to water_bioresources_statistic_url(id: @water_bioresource.id, page: 1)
  end

  private

  def statistic_with_catch
    @catches_max_weight = Catch.statistic_max_weight(current_user.id, 'water_bioresource', @water_bioresource.id)
    @catches_max_length = Catch.statistic_max_length(current_user.id, 'water_bioresource', @water_bioresource.id)
    @fishing_places = FishingPlace.statistic_all_records(current_user.id, 'water_bioresource', @water_bioresource.id)
    @equipments = Tool.statistic_all_tool_type_records(current_user.id, 'water_bioresource', @water_bioresource.id,
                                                       'equipment')
    @baits = Tool.statistic_all_tool_type_records(current_user.id, 'water_bioresource', @water_bioresource.id,
                                                  'bait')
  end

  def set_water_bioresource
    @water_bioresource = WaterBioresource.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def water_bioresource_params
    params.require(:water_bioresource).permit(:name, :latin_name, :resource_type, :bioresource_photo,
                                              :bioresource_description)
  end
end
