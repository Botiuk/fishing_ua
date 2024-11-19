# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_url, alert: t('alert.access_denied')
  end
end
