class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|

      t.timestamps
    end
  end
end
