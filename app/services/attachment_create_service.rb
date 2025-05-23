# frozen_string_literal: true

class AttachmentCreateService
  attr_reader :object, :file, :filename, :content_type

  def initialize(object, file, filename = nil)
    @object = object
    @filename = filename || file.try(:original_filename) || file.try(:filename)
    @content_type = file.try(:content_type) || file.try(:type)
    @file = file.is_a?(StringIO) ? file : file.open || file.tempfile.open
  end

  def self.call(object, file, filename = nil)
    new(object, file, filename).call
  end

  def call
    blob = check_file(file)
    create_attachment(blob)
  end

  private

  def check_file(file)
    checksum = ActiveStorage::Blob.new.send(:compute_checksum_in_chunks, file)
    blob = ActiveStorage::Blob.find_by(checksum:)
    unless object.attachments.joins(file_attachment: :blob)
                         .where(active_storage_blobs: { checksum: }).exists?
      blob
    end
  end

  def create_attachment(blob)
    attachment = object.attachments.create
    if blob.present?
      ActiveStorage::Attachment.create!(
        name: 'file',
        record_type: attachment.class,
        record_id: attachment.id,
        blob_id: blob.id
      )
    else
      attachment.file.attach(
        io: StringIO.new(file.read),
        filename:,
        content_type:
      )
    end
    file.close
    attachment
  end
end
