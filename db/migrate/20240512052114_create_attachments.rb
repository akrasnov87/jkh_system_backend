class CreateAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :attachments do |t|
      t.bigint :attachable_id
      t.string :attachable_type

      t.timestamps
    end
  end
end
