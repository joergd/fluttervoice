class ChangeCreditCardTransaction < ActiveRecord::Migration
  def self.up
    rename_column :credit_card_transactions, :order_number, :reference

    remove_column :credit_card_transactions, :cc_address1
    remove_column :credit_card_transactions, :cc_address2
    remove_column :credit_card_transactions, :cc_postalcode
    remove_column :credit_card_transactions, :cc_city
    remove_column :credit_card_transactions, :cc_country
    remove_column :credit_card_transactions, :cc_last_4_digits
    remove_column :credit_card_transactions, :cc_expiry
    remove_column :credit_card_transactions, :currency
    remove_column :credit_card_transactions, :vp_cross_reference
    remove_column :credit_card_transactions, :vp_old_cross_reference

    add_column :credit_card_transactions, :response, :string
    add_column :credit_card_transactions, :description, :string
    add_column :credit_card_transactions, :cc_email, :string
  end

  def self.down
  end
end
