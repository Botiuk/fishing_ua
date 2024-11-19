# frozen_string_literal: true

class DayRatesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_day_rate, only: %i[edit update destroy]
  before_action :water_bioresources_formhelper, only: %i[new create edit update]
  authorize_resource

  def index
    @pagy, @day_rates = pagy(
      DayRate.includes(:water_bioresource).joins(:water_bioresource).order('water_bioresources.name'), items: 10
    )
  rescue Pagy::OverflowError
    redirect_to day_rates_url(page: 1)
  end

  def new
    @day_rate = DayRate.new
  end

  def edit
    @water_bioresources += WaterBioresource.where(id: @day_rate.water_bioresource.id).pluck(:name, :id)
  end

  def create
    @day_rate = DayRate.new(day_rate_params)
    if @day_rate.save
      redirect_to day_rates_url, notice: t('notice.create.day_rate')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @day_rate.update(day_rate_params)
      redirect_to day_rates_url, notice: t('notice.update.day_rate')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @day_rate.destroy
    redirect_to day_rates_url, notice: t('notice.destroy.day_rate')
  end

  private

  def set_day_rate
    @day_rate = DayRate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def water_bioresources_formhelper
    water_bioresources_with_day_rate_ids = DayRate.pluck(:water_bioresource_id)
    @water_bioresources = WaterBioresource.where.not(id: water_bioresources_with_day_rate_ids).order(:name).pluck(
      :name, :id
    )
  end

  def day_rate_params
    params.require(:day_rate).permit(:water_bioresource_id, :catch_amount, :amount_type)
  end
end
