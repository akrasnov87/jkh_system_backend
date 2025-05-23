class Reply < ApplicationRecord
  include Attachable

  KINDS = {
    client: 0,
    staff: 1
  }.freeze
  belongs_to :user
  belongs_to :ticket, touch: true

  enum kind: KINDS
end
