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

        #Validation rules according to client and developers insights
        if row[0].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'C.C' esta vacio.", request.remote_ip]
				end
        if (!row[1].blank? && (!["C","S"].include? row[1].upcase))
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Estado civil' debe ser: S o C. (Valor ingresado: #{row[1]})", request.remote_ip]
				end
        if row[2].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Sexo' esta vacio.", request.remote_ip]
				end
        if (!row[2].blank? && (!["F","M"].include? row[2].upcase))
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Sexo' debe ser: F o M. (Valor ingresado: #{row[2]})", request.remote_ip]
				end
        if row[3].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Nacionalidad' esta vacio.", request.remote_ip]
				end
        if (!row[3].blank? && (!["C","E"].include? row[3].upcase))
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Nacionalidad' debe ser: C o E. (Valor ingresado: #{row[3]})", request.remote_ip]
				end
        if row[4].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Nombre' no puede ser vacio", request.remote_ip]
				end
        if row[5].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Apellido' no puede ser vacio", request.remote_ip]
				end
        if (!row[9].blank? && (false if Date.strptime(row[9], '%d/%m/%Y') rescue true))
					row[9] = false if DateTime.parse(row[9].to_s) rescue true
					row[9] = false if row[9].strftime("%d/%m/%Y") rescue true
					if (!row[9].blank? && (false if Date.strptime(row[9], '%d/%m/%Y') rescue true))
						err = 1
						session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Fecha de Nacimiento' contiene formato incorrecto: #{row[9]}. (Ejemplo: 31/12/2016)", request.remote_ip]
					end
				end
        if row[10].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Profesion' no puede ser vacio", request.remote_ip]
				end
        if row[11].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Municipio' no puede ser vacio", request.remote_ip]
				end
        if row[12].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Tipo de Personal' no puede ser vacio", request.remote_ip]
				end
        if (!row[12].blank? && (!["CS","ES","JA","JU","OR","PE"].include? row[12].upcase))
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Tipo de Personal' debe ser: CS, ES, JA, JU, OR o PE. (Valor ingresado: #{row[12]})", request.remote_ip]
				end
        if row[13].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Tipo de Dedicacion' no puede ser vacio", request.remote_ip]
				end
        if (!row[13].blank? && (!["CO","DE","MT","TC"].include? row[13].upcase))
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Tipo de Dedicacion' debe ser: CO, DE, MT o TC. (Valor ingresado: #{row[13]})", request.remote_ip]
				end
        if row[14].blank?
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Tipo de Categoria' no puede ser vacio", request.remote_ip]
				end
        if (!row[14].blank? && (!["AG","AS","AT","I","NA","T"].include? row[14].upcase))
					err = 1
					session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El campo 'Tipo de Categoria' debe ser: AG, AS, AT, I, NA o T. (Valor ingresado: #{row[14]})", request.remote_ip]
				end

        if (err == 0)
          unless Docente.exists?(cedula: row[0])
						docente = Docente.new
						docente.cedula = row[0]
            docente.estado_civil = row[1]
						docente.genero = row[2]
            docente.nacionalidad = row[3]
            docente.nombre = row[4]
            docente.apellido = row[5]
            docente.email = row[6]
            docente.numero_fijo = row[7]
            docente.numero_celular = row[8]
            docente.fecha_nacimiento = row [9]
            docente.profesion = row[10]
            docente.municipio = row[11]
						docente.save
						ok_log += 1
					else
						session[:log_mig_doc] << [Time.now.strftime("%Y-%m-%d %I:%M%p"), "Registro #{i-10}", "El docente ya existe. (C.C: #{row[0]})", request.remote_ip]
						rep_log += 1
					end
        else
					err_log += 1
				end

      end
      #Log the stuff that just happened
      Bitacora.create(usuario_sesion: session[:user]["nombre"]+" "+session[:user]["apellido"], ip_origen: request.remote_ip, descripcion: "Migracion de datos: Se ingresaron #{ok_log} registros correctamente, #{rep_log} registros repetidos, #{err_log} registros con errores")

      redirect_to action: :index
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
