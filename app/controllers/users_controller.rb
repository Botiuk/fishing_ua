class UsersController < ApplicationController
    before_action :set_user, only: :update
    load_and_authorize_resource

    def index
        @pagy, @users = pagy(User.order(role: :desc, email: :asc), items: 10)
    rescue Pagy::OverflowError
        redirect_to users_url(page: 1)
    end

    def search
        if params[:email].blank?
            redirect_to users_url, alert: t('alert.search_user')
        else
            @pagy, @users = pagy(User.where('email LIKE ?', "%" + params[:email] + "%").order(role: :desc, email: :asc), items: 10)
            @search_params = params[:email]
        end
    rescue Pagy::OverflowError
        redirect_to users_url(page: 1)
    end

    def update
        if @user.update(user_params)
            redirect_to users_url, notice: t('notice.update.user_role')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private
    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def user_params
        params.require(:user).permit(:email, :role)
    end
end
