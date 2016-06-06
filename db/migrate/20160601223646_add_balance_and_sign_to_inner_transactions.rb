class AddBalanceAndSignToInnerTransactions < ActiveRecord::Migration
  def change
    add_reference :inner_transactions, :balance, index: true, foreign_key: true
    add_column :inner_transactions, :sign, :string
  end
end
