class ApplicationController < ActionController::Base
    include Pagy::Backend

    before_action :authenticate_user!

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, alert: t('alert.access_denied')
    end
end
