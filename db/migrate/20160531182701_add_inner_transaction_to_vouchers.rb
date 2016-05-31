class AddInnerTransactionToVouchers < ActiveRecord::Migration
  def change
    add_reference :vouchers, :inner_transaction, index: true, foreign_key: true
  end
end
