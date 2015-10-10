class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :token
      t.float :amount
      t.string :status

      t.timestamps null: false
    end
  end
end
