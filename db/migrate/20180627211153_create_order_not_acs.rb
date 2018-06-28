class CreateOrderNotAcs < ActiveRecord::Migration[5.2]
  def up
    create_table :ellie_order_not_acs do |t|
      t.string :order_name
    end
  end

  def down
    drop_table :ellie_order_not_acs
  end
end
