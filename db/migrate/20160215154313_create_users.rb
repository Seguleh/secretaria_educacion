class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :apellido
      t.string :email
      t.integer :numero_fijo, :limit => 12
      t.integer :numero_celular, :limit => 12
      t.string :profesion
      t.string :municipio
      t.date :fecha_nacimiento

      t.timestamps null: false
    end
  end
end
