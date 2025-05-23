class Attachment < ApplicationRecord
  EXTENSION_WHITE_LIST = %w(xls xlsx doc docx pdf rtf csv txt jpg jpeg gif png tiff bmp jpe).freeze
  belongs_to :attachable, polymorphic: true

  has_one_attached :file, dependent: :detached

  validate :file_extension_allowed

  enum kind: { default: 0, icon: 1 }

  def url
    Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  def file_extension_allowed
    return unless file.attached?

    return unless file.blob.present?

    extension = file.blob.filename.extension_without_delimiter
    return if EXTENSION_WHITE_LIST.include?(extension.downcase)

    errors.add(:file, "должен быть в формате: #{EXTENSION_WHITE_LIST.join(', ')}")
  end
end
