class AddedDeviseId < ActiveRecord::Migration[7.1]
  def change
    rename_column :api_tokens, :devise_id, :device_id
  end
end
