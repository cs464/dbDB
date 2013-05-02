class CreatePursuings < ActiveRecord::Migration
  def change
    create_table :pursuings do |t|

      t.timestamps
    end
  end
end
