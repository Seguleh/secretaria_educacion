class CreateBitacoras < ActiveRecord::Migration
  def change
    create_table :bitacoras do |t|
      t.string :usuario_sesion
      t.datetime :fecha_hora
      t.string :ip_origen
      t.string :descripcion

      t.timestamps null: false
    end
  end
end
