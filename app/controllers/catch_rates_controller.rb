# frozen_string_literal: true

class CatchRatesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_catch_rate, only: %i[edit update destroy]
  before_action :water_bioresources_formhelper, only: %i[new create edit]
  authorize_resource

  def index
    @pagy, @catch_rates = pagy(CatchRate.includes(:water_bioresource).ordered, items: 10)
  rescue Pagy::OverflowError
    redirect_to catch_rates_url(page: 1)
  end

  def new
    @catch_rate = CatchRate.new
  end

  def edit
    @water_bioresources += WaterBioresource.where(id: @catch_rate.water_bioresource.id).pluck(:name, :id)
  end

  def create
    @catch_rate = CatchRate.new(catch_rate_params)
    if @catch_rate.save
      redirect_to catch_rates_url, notice: t('notice.create.catch_rate')
    else
      render :new, status: :unprocessable_entity
    end
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
    water_bioresources_with_catch_rate_ids = CatchRate.pluck(:water_bioresource_id)
    @water_bioresources = WaterBioresource.where.not(id: water_bioresources_with_catch_rate_ids).order(:name).pluck(
      :name, :id
    )
  end

  def catch_rate_params
    params.require(:catch_rate).permit(:water_bioresource_id, :length_dnipro, :length_other, :length_black,
                                       :length_azov)
  end
end
