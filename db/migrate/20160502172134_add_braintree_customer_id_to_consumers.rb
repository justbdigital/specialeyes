class AddBraintreeCustomerIdToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :braintree_customer_id, :integer
  end
end
