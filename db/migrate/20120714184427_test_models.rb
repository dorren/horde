class TestModels < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :login,      :limit => 64
      t.string :email,      :limit => 64
      t.string :first_name, :limit => 64
      t.string :last_name,  :limit => 64

      t.timestamps
    end

    create_table :profiles do |t|
      t.string :avatar_url, :limit => 256
      t.string :age,        :limit => 64
      t.string :sex,        :limit => 64
      t.string :location,   :limit => 64
      t.references :user

      t.timestamps
    end

    create_table :articles do |t|
      t.string :title
      t.string :body
      t.string :author_id

      t.timestamps
    end

    create_table :photos do |t|
      t.string :name
      t.string :author_id

      t.timestamps
    end
  end

  def down
    drop_table :users
    drop_table :profiles
    drop_table :articles
    drop_table :photos
  end
end
