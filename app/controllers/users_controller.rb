class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :destroy, :create, :index]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :create, :index, :show]


  def index

    @users = User.paginate(page: params[:page])

  end

  def new

  	@user = User.new

  end

  def show

  	@user = User.find(params[:id])

  end

  def create

  	@user = User.new(user_params)

  	if @user.save

      @user.send_activation_email
  		flash[:info] = "Se envió un correo al usuario, favor indicarle para que active su cuenta."
  		redirect_to root_url

  	else

  		render 'new'
      
  	end

  end

  def edit

    @user = User.find(params[:id])

    if @user.update_attributes(user_params)

      flash[:success] = "Modificación exitosa!"
      redirect_to root_url

    else

      render 'edit'

    end
  end

  def destroy

    User.find(params[:id]).destroy
    flash[:success] = "Usuario eliminado"
    redirect_to users_url

  end

  private

  	def user_params

  		params.require(:user).permit(:nombre, :apellido, :email, :numero_fijo, :numero_celular, :fecha_nacimiento, :profesion, :municipio, :password, :password_confirmation)
  	
    end

    def logged_in_user

      unless logged_in?
        store_location
        flash[:danger] = "Por favor iniciar sesión."
        redirect_to login_url
      end

    end

    def correct_user

      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)

    end

    def admin_user

      redirect_to(root_url) unless current_user.admin?

    end

end

