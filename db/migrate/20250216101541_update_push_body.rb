class UpdatePushBody < ActiveRecord::Migration[7.1]
  def change
    change_column_null :pushes, :body, false
  end
end
