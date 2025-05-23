class AddKindToAttachments < ActiveRecord::Migration[7.1]
  def change
    add_column :attachments, :kind, :integer, default: 0
  end
end
