# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_06_28_005920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ellie_order_not_acs", force: :cascade do |t|
    t.string "order_name"
  end

  create_table "ellie_shopify_orders", force: :cascade do |t|
    t.string "app_id"
    t.jsonb "billing_address1"
    t.jsonb "billing_address2"
    t.string "browser_ip"
    t.boolean "buyer_accepts_marketing"
    t.string "cancel_reason"
    t.datetime "cancelled_at"
    t.string "cart_token"
    t.jsonb "client_details"
    t.datetime "closed_at"
    t.datetime "created_at"
    t.string "currency"
    t.jsonb "customer"
    t.string "customer_locale"
    t.jsonb "discount_applications"
    t.jsonb "discount_codes"
    t.string "email"
    t.string "financial_status"
    t.jsonb "fulfillments"
    t.string "fulfillment_status"
    t.string "landing_site"
    t.jsonb "line_items"
    t.string "location_id"
    t.string "name"
    t.string "note"
    t.jsonb "note_attributes"
    t.bigint "number"
    t.bigint "order_number"
    t.string "payment_gateway_names"
    t.string "phone"
    t.string "processed_at"
    t.string "processing_method"
    t.string "referring_site"
    t.jsonb "refunds"
    t.jsonb "shipping_address"
    t.jsonb "shipping_lines"
    t.string "source_name"
    t.integer "subtotal_price"
    t.string "tags"
    t.jsonb "tax_lines"
    t.boolean "taxes_included"
    t.string "token"
    t.string "total_discounts"
    t.string "total_line_items_price"
    t.string "total_price"
    t.string "total_tax"
    t.bigint "total_weight"
    t.datetime "updated_at"
    t.bigint "user_id"
    t.string "order_status_url"
  end

end
