# frozen_string_literal: true

class FishingSessionsController < ApplicationController
  before_action :set_fishing_session, only: %i[show edit update]
  before_action :fishing_place_formhelper, only: %i[new create edit update]
  authorize_resource

  def index
    @pagy, @fishing_sessions = pagy(
      FishingSession.where(user_id: current_user.id).order(start_at: :desc, id: :desc), items: 10
    )
    fishing_session_ids = FishingSession.where(user_id: current_user.id).ids
    @fishing_session_catches_count = Catch.where(fishing_session_id: fishing_session_ids)
                                          .group(:fishing_session_id).count
  rescue Pagy::OverflowError
    redirect_to fishing_sessions_url(page: 1)
  end

  def show
    @pagy, @catches = pagy(
      Catch.includes(:water_bioresource)
           .statistic_all_records(current_user.id, 'fishing_session', @fishing_session.id), items: 10
    )
    fishing_session_duration
    statistic_with_catch if @catches.present?
  rescue Pagy::OverflowError
    redirect_to fishing_session_url(@fishing_session, page: 1)
  end

  def new
    last_fishing_session = FishingSession.where(user_id: current_user.id, end_at: nil).last
    if last_fishing_session.blank?
      if @fishing_places.present?
        @fishing_session = FishingSession.new
      else
        redirect_to new_fishing_place_url, alert: t('alert.new.session_place')
      end
    else
      redirect_to fishing_session_url(last_fishing_session), alert: t('alert.new.fishing_session')
    end
  end

  def edit
    if @fishing_session.end_at.present?
      redirect_to fishing_session_url(@fishing_session), alert: t('alert.fishing_session_close')
    end
    @catch_pick_up = Catch.find_by(fishing_session_id: @fishing_session.id, catch_result: 'pick_up')
  end

  def create
    @fishing_session = FishingSession.new(fishing_session_params)
    @fishing_session.user_id = current_user.id
    if @fishing_session.save
      redirect_to fishing_session_url(@fishing_session), notice: t('notice.create.fishing_session')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @fishing_session.update(fishing_session_params)
      if @fishing_session.end_at.blank?
        redirect_to fishing_session_url(@fishing_session), notice: t('notice.update.fishing_session')
      else
        redirect_to fishing_session_url(@fishing_session), notice: t('notice.update.fishing_session_close')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def statistic_with_catch
    @catches_max_weight = Catch.statistic_max_weight(current_user.id, 'fishing_session', @fishing_session.id)
    @catches_max_length = Catch.statistic_max_length(current_user.id, 'fishing_session', @fishing_session.id)
    @water_bioresources = WaterBioresource.statistic_all_records(current_user.id, 'fishing_session',
                                                                 @fishing_session.id)
    @equipments = Tool.statistic_all_tool_type_records(current_user.id, 'fishing_session', @fishing_session.id,
                                                       'equipment')
    @baits = Tool.statistic_all_tool_type_records(current_user.id, 'fishing_session', @fishing_session.id, 'bait')
  end

  def set_fishing_session
    @fishing_session = FishingSession.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def fishing_place_formhelper
    @fishing_places = FishingPlace.where(user_id: current_user.id).order(:name).pluck(:name, :id)
  end

  def fishing_session_params
    params.require(:fishing_session).permit(:start_at, :end_at, :user_id, :fishing_place_id)
  end

  def fishing_session_duration
    duration_seconds = if @fishing_session.end_at.nil?
                         Time.zone.now - @fishing_session.start_at
                       else
                         @fishing_session.end_at - @fishing_session.start_at
                       end
    duration_days = (duration_seconds / 86_400).to_i
    duration_day_seconds = (duration_seconds % 86_400)
    duration_time = Time.at(duration_day_seconds).utc.strftime '%H:%M'
    @duration = "#{duration_days} #{I18n.t('statistic.duration_days')} #{duration_time}"
  end
end
