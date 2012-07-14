class HordeSetup < ActiveRecord::Migration
  def up
    create_table :horde_favorites do |t|
      t.string :actor_id,    :limit => 64
      t.string :target_type, :limit => 64
      t.string :target_id,   :limit => 64

      t.timestamps
    end
  end

  def down
    drop_table :horde_favorites
  end
end
