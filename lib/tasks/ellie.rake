namespace :shopify do

  desc "save ellie orders from June"
  task :save_ellie_orders => :environment do |t|
    ActiveRecord::Base.connection.execute("TRUNCATE ellie_shopify_orders;") if EllieShopifyOrder.exists?
      EllieHelper::OrderPull.new.save_all
  end

  desc "load not in acs file"
  task :load_not_acs_file => :environment  do |t|
    ActiveRecord::Base.connection.execute("TRUNCATE ellie_order_not_acs;") if EllieOrderNotACS.exists?
    EllieHelper::OrderPull.new.import_csv
  end


end
