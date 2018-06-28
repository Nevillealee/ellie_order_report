
module EllieHelper
  class OrderPull
    SHOPIFY_ORDERS = []

    def save_all
      init_orders
      SHOPIFY_ORDERS.each do |order|
        puts "saving #{order['id']}"
        begin
        EllieShopifyOrder.create(
          id: order['id'],
          app_id: order['app_id'],
          billing_address1: order['billing_address1'],
          billing_address2: order['billing_address2'],
          browser_ip: order['browser_ip'],
          buyer_accepts_marketing: order['buyer_accepts_marketing'],
          cancel_reason: order['cancel_reason'],
          cancelled_at: order['cancelled_at'],
          cart_token: order['cart_token'],
          client_details: order['client_details'],
          closed_at: order['closed_at'],
          created_at: order['created_at'],
          currency: order['currency',],
          customer: order['customer'],
          customer_locale: order['customer_locale'],
          discount_applications: order['discount_applications'],
          discount_codes: order['discount_codes'],
          email: order['email'],
          financial_status: order['financial_status'],
          fulfillments: order['fulfillments'],
          fulfillment_status: order['fulfillment_status'],
          landing_site: order['landing_site'],
          line_items: order['line_items'],
          location_id: order['location_id'],
          name: order['name'],
          note: order['note'],
          note_attributes: order['note_attributes'],
          number: order['number'],
          order_number: order['order_number'],
          payment_gateway_names: order['payment_gateway_names'],
          phone: order['phone'],
          processed_at: order['processed_at'],
          processing_method: order['processing_method'],
          referring_site: order['referring_site'],
          refunds: order['refunds'],
          shipping_address: order['shipping_address'],
          shipping_lines: order['shipping_lines'],
          source_name: order['source_name'],
          subtotal_price: order['subtotal_price'],
          tags: order['tags'],
          tax_lines: order['tax_lines'],
          taxes_included: order['taxes_included'],
          token: order['token'],
          total_discounts: order['total_discounts'],
          total_line_items_price: order['total_line_items_price'],
          total_price: order['total_price'],
          total_tax: order['total_tax'],
          total_weight: order['total_weight'],
          updated_at: order['updated_at'],
          user_id: order['user_id'],
          order_status_url: order['order_status_url']
        )
      rescue => e
          puts "error with order id: #{order['id']}"
          puts e.message
          next
        end
      end
      puts "shopify orders saved to db.."
    end

    def api_throttle
      ShopifyAPI::Base.site =
        "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
        return if ShopifyAPI.credit_left > 5
        put "api limit reached sleeping 10.."
        sleep 10
    end

    def init_orders

      ShopifyAPI::Base.site =
        "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
      my_min = '2018-06-01T00:00:00-04:00'
      my_max = '2018-06-26T23:59:59-04:00'
      order_count = ShopifyAPI::Order.count( created_at_min: my_min, created_at_max: my_max, status: 'any')
      nb_pages = (order_count / 250.0).ceil
      puts "#{order_count} orders to pull"

      1.upto(nb_pages) do |page|
        ellie_active_url =
          "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin/orders.json?limit=250&page=#{page}&created_at_min=#{my_min}&created_at_max=#{my_max}&status=any"
        @parsed_response = HTTParty.get(ellie_active_url)

        SHOPIFY_ORDERS.push(@parsed_response['orders'])
        p "active orders set #{page}/#{nb_pages} loaded"
        # sleep 3
      end

      p 'active orders initialized'
      SHOPIFY_ORDERS.flatten!
    end

    def import_csv
      puts 'importing csv...'
      CSV.foreach(Rails.root.join('june_ellie_orders_not_acs.csv'), headers: true) do |row|
        EllieOrderNotACS.create(row.to_h)
      end
      puts "import complete"
    end

    def export_csv
      column_header = [
        "charge_id",
        "code",
        "price",
        "source",
        "title",
        "tax_lines",
        "carrier_identifier",
        "request_fulfillment_service_id"
      ]
      File.delete('shipping_lines.csv') if File.exist?('shipping_lines.csv')
      shipping_lines = ChargeShippingLine.all

      CSV.open('shipping_lines.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
      column_header = nil
      shipping_lines.each do |shipping_line|
        puts shipping_line.inspect
        #Construct the CSV string
        charge_id = shipping_line.charge_id
        code = shipping_line.code
        price = shipping_line.price
        source = shipping_line.source
        title = shipping_line.title
        tax_lines = shipping_line.tax_lines
        carrier_identifier = shipping_line.carrier_identifier
        request_fulfillment_service_id = shipping_line.request_fulfillment_service_id

        csv_data_out = [
          charge_id,
          code,
          price,
          source,
          title,
          tax_lines,
          carrier_identifier,
          request_fulfillment_service_id
        ]
          hdr << csv_data_out
        end
      end
    end

  end
end
