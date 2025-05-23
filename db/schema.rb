# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_19_151142) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "external_id", null: false
    t.string "number", null: false
    t.datetime "date_begin"
    t.datetime "date_end"
    t.string "address"
    t.string "full_name"
    t.integer "company", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "apart_name"
    t.string "apart_name_ext"
    t.string "house"
    t.index ["external_id"], name: "index_accounts_on_external_id"
    t.index ["number"], name: "index_accounts_on_number"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.string "device_id"
    t.integer "kind", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token"
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "attachable_id"
    t.string "attachable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0
  end

  create_table "charges", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "year", null: false
    t.integer "month", null: false
    t.string "service_name", null: false
    t.string "tariff"
    t.text "unit"
    t.string "norm"
    t.text "norm_unit"
    t.string "sum_nach"
    t.string "sum_recalc"
    t.string "sum_nach_all"
    t.string "consume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_charges_on_account_id"
  end

  create_table "company_details", force: :cascade do |t|
    t.integer "company", default: 0, null: false
    t.string "name", null: false
    t.string "address", null: false
    t.string "inn", null: false
    t.string "kpp", null: false
    t.string "bill_type", null: false
    t.string "bill_number", null: false
    t.string "bank_name", null: false
    t.string "bik", null: false
    t.string "bill_cor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_infos", force: :cascade do |t|
    t.integer "company", default: 0, null: false
    t.string "address", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "email", default: "", null: false
    t.text "working_schedules", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_phones", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "counters", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "external_id"
    t.string "counter_name"
    t.string "serial_code"
    t.string "service_name"
    t.string "service_group"
    t.datetime "last_check"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.index ["account_id"], name: "index_counters_on_account_id"
    t.index ["external_id"], name: "index_counters_on_external_id"
  end

  create_table "counters_values", force: :cascade do |t|
    t.bigint "counter_id", null: false
    t.decimal "val"
    t.integer "year"
    t.integer "month"
    t.boolean "is_consume", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["counter_id"], name: "index_counters_values_on_counter_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emergency_phones", force: :cascade do |t|
    t.integer "company", null: false
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "company"
    t.integer "image", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "active", default: false, null: false
    t.string "whodunit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "house"
    t.integer "kind", default: 0, null: false
    t.integer "url_action"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "month"
    t.string "year"
    t.decimal "sum_to_pay", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "actual_payment", default: false, null: false
    t.index ["account_id"], name: "index_orders_on_account_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "status", default: 0, null: false
    t.string "order_id"
    t.string "rq_uid", null: false
    t.string "order_form_url"
    t.string "order_sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "id_qr"
    t.integer "kind", default: 0
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["status"], name: "index_payments_on_status"
  end

  create_table "push_templates", force: :cascade do |t|
    t.string "title", null: false
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company"
    t.jsonb "data", default: {}
    t.index ["company"], name: "index_push_templates_on_company"
  end

  create_table "pushes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "body", null: false
    t.string "whodunit", null: false
    t.boolean "is_new", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data", default: {}
    t.index ["user_id"], name: "index_pushes_on_user_id"
  end

  create_table "replies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ticket_id", null: false
    t.integer "kind", default: 0, null: false
    t.string "subject"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_replies_on_ticket_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.integer "company", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_categories", force: :cascade do |t|
    t.integer "company", null: false
    t.string "name", null: false
    t.integer "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
  end

  create_table "service_orders", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "user_id"
    t.bigint "service_category_id"
    t.bigint "service_work_id"
    t.integer "status", default: 0
    t.string "subject", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.string "full_name", null: false
    t.string "number", null: false
    t.index ["account_id"], name: "index_service_orders_on_account_id"
    t.index ["service_category_id"], name: "index_service_orders_on_service_category_id"
    t.index ["service_work_id"], name: "index_service_orders_on_service_work_id"
    t.index ["status"], name: "index_service_orders_on_status"
    t.index ["subject"], name: "index_service_orders_on_subject"
    t.index ["user_id"], name: "index_service_orders_on_user_id"
  end

  create_table "service_payments", force: :cascade do |t|
    t.bigint "service_order_id", null: false
    t.integer "status", default: 0, null: false
    t.string "order_id"
    t.string "rq_uid", null: false
    t.string "order_form_url"
    t.string "order_sum"
    t.string "id_qr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_service_payments_on_deleted_at"
    t.index ["service_order_id"], name: "index_service_payments_on_service_order_id"
    t.index ["status"], name: "index_service_payments_on_status"
  end

  create_table "service_replies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "service_order_id", null: false
    t.integer "kind", default: 0, null: false
    t.string "subject"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_order_id"], name: "index_service_replies_on_service_order_id"
    t.index ["user_id"], name: "index_service_replies_on_user_id"
  end

  create_table "service_works", force: :cascade do |t|
    t.bigint "service_category_id", null: false
    t.string "name", null: false
    t.integer "company", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["service_category_id"], name: "index_service_works_on_service_category_id"
  end

  create_table "tariffs", force: :cascade do |t|
    t.integer "company", default: 0, null: false
    t.string "name", null: false
    t.string "explanation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subject"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.bigint "account_id"
    t.datetime "sla_started_at"
    t.boolean "sla_expired", default: false, null: false
    t.integer "department", default: 0, null: false
    t.bigint "department_id"
    t.integer "origin", default: 0
    t.index ["account_id"], name: "index_tickets_on_account_id"
    t.index ["department_id"], name: "index_tickets_on_department_id"
    t.index ["sla_started_at"], name: "index_tickets_on_sla_started_at"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "useful_contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "number", null: false
    t.integer "company", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_push_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.string "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id", "token"], name: "index_user_push_tokens_on_device_id_and_token", unique: true
    t.index ["user_id"], name: "index_user_push_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "full_name"
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sms_code_failed_attempts", default: 0, null: false
    t.string "sms_code"
    t.datetime "sms_code_sended_at"
    t.string "companies", default: [], array: true
    t.boolean "send_push_notifications", default: true, null: false
    t.bigint "department_id"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["send_push_notifications"], name: "index_users_on_send_push_notifications"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "orders", "accounts"
end
