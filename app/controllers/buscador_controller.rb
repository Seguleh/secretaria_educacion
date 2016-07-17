class BuscadorController < ApplicationController

  before_action :logged_in_user, only: [:index, :upload]
  before_action :correct_user,   only: [:index, :upload]
  before_action :admin_user,     only: [:index, :upload]

  def index
  end

  def find

    # @users = User.find_each
    @users = User.where(profesion: params[:profesion])

    render 'index'

  end

  private

    def logged_in_user

      unless logged_in?
        store_location
        flash[:danger] = "Por favor iniciar sesión."
        redirect_to login_url
      end

    end

    def correct_user

      @user = User.find(session[:user_id])
      redirect_to(root_url) unless current_user?(@user)

    end

    def admin_user

      redirect_to(root_url) unless current_user.admin?
    end

end
