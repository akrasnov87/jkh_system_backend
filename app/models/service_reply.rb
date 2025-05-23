class ServiceReply < ApplicationRecord
  include Attachable

  KINDS = {
    client: 0,
    staff: 1
  }.freeze
  belongs_to :user
  belongs_to :service_order, touch: true

  enum kind: KINDS
end
