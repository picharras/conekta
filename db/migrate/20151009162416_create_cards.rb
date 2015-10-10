class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :number
      t.string :expiration
      t.string :token
      t.float :amount

      t.timestamps null: false
    end
  end
end
