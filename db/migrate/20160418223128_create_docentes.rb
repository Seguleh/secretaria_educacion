class CreateDocentes < ActiveRecord::Migration
  def change
    create_table :docentes do |t|
      t.string :nombre
      t.string :apellido
      t.string :email
      t.integer :numero_fijo
      t.integer :numero_celular
      t.string :profesion
      t.string :municipio
      t.date :fecha_nacimiento

      t.timestamps null: false
    end
  end
end
