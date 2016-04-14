class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :pro
      t.string :holder_name
      t.string :account_number
      t.string :bank_name
      t.string :bank_sort_code
      t.string :bank_address
      t.string :postcode
      t.string :country

      t.timestamps null: false
    end
  end
end
