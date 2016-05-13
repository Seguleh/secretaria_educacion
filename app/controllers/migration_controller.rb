class MigrationController < ApplicationController

  before_action :logged_in_user, only: [:index, :upload]
  before_action :correct_user,   only: [:index, :upload]
  before_action :admin_user,     only: [:index, :upload]

  def index
  end

  def upload

    if ((!params[:file]) || (params[:file].original_filename != "archivo_modelo.xls"))
      flash[:danger] = "No cargo el archivo correcto"
      render 'index'
    else

      migration = Spreadsheet.open(params[:file].tempfile)
      sheet = migration.worksheet 0
      session[:log_mig_est] = Array.new
      err = err_log = rep_log = ok_log = 0

      (12..sheet.row_count).each do |i|

        row = sheet.row(i)

        if row.blank? || row.empty?
          break
        end

        err = 0

        #Time to validate


        #Time to log the stuff that just happened
        Bitacora.new(usuario_sesion: session[:user].nombre+" "+session[:user].apellido, fecha_hora: Time.now, ip_origen: request.remote_ip, descripcion: descripcion)

      end

    end

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
