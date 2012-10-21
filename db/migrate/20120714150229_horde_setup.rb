class HordeSetup < ActiveRecord::Migration
  def up
    create_table :horde_favorites do |t|
      t.string :actor_id,    :limit => 64
      t.string :target_type, :limit => 64
      t.string :target_id,   :limit => 64

      t.timestamps
    end
    add_index :horde_favorites, :actor_id
    add_index :horde_favorites, [:target_id, :target_type]


    create_table :horde_follows do |t|
      t.string :actor_id,    :limit => 64
      t.string :target_type, :limit => 64
      t.string :target_id,   :limit => 64

      t.timestamps
    end
    add_index :horde_follows, :actor_id
    add_index :horde_follows, [:target_id, :target_type]


    create_table :horde_comments do |t|
      t.string :actor_id,    :limit => 64
      t.string :target_type, :limit => 64
      t.string :target_id,   :limit => 64
      t.string :comment,     :limit => 2048
      t.integer :abuse_count, :default => 0

      t.timestamps
    end
    add_index :horde_comments, :actor_id
    add_index :horde_comments, [:target_id, :target_type]
    add_index :horde_comments, :abuse_count


    create_table :horde_rates do |t|
      t.string :actor_id,    :limit => 64
      t.string :target_type, :limit => 64
      t.string :target_id,   :limit => 64
      t.integer :score

      t.timestamps
    end
    add_index :horde_rates, :actor_id
    add_index :horde_rates, [:target_id, :target_type]
  end

  def down
    drop_table :horde_favorites
    drop_table :horde_comments
    drop_table :horde_follows
    drop_table :horde_rates
  end
end
