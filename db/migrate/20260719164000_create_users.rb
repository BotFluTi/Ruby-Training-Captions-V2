# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |table|
      table.string :username, null: false
      table.string :password_digest, null: false
      table.string :token, null: false

      table.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :token, unique: true
  end
end
