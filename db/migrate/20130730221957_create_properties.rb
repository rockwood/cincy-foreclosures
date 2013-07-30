class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :case_number
      t.string :plaintiff
      t.string :owner
      t.string :address
      t.string :township
      t.string :attorney
      t.string :attorney_phone
      t.string :appraisal
      t.string :minimum_bid
      t.date :sale_date
      t.boolean :withdrawn

      t.timestamps
    end
  end
end
