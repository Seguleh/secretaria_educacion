class UsersController < ApplicationController

  def new

  	@user = User.new

  end

  def show

  	@user = User.find(params[:id])

  end

  def create

  	@user = User.new(user_params)

  	if @user.save
  		flash[:success] = "Gracias por completar el registro!"
  		redirect_to @user
  	else
  		render 'new'
  	end

  end

  private

  	def user_params
  		params.require(:user).permit(:nombre, :apellido, :email, :numero_fijo, :numero_celular, :fecha_nacimiento, :profesion, :municipio, :password, :password_confirmation)
  	end

end

