class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table "accounts" do |t|
      t.column "subdomain",                  :string,    :limit => 30,  :default => "", :null => false
      t.column "plan_id",                    :integer,                  :default => 1,  :null => false
      t.column "effective_date",             :date,                                     :null => false
      t.column "primary_person_id",          :integer,                  :default => 0,  :null => false
      t.column "name",                       :string,                   :default => "", :null => false
      t.column "address1",                   :string,                   :default => "", :null => false
      t.column "address2",                   :string,                   :default => "", :null => false
      t.column "city",                       :string,                   :default => "", :null => false
      t.column "state",                      :string,                   :default => "", :null => false
      t.column "postalcode",                 :string,    :limit => 15,  :default => "", :null => false
      t.column "country",                    :string,                   :default => "", :null => false
      t.column "web",                        :string,                   :default => "", :null => false
      t.column "tel",                        :string,    :limit => 30,  :default => "", :null => false
      t.column "fax",                        :string,    :limit => 30,  :default => "", :null => false
      t.column "vat_registration",           :string,    :limit => 50,  :default => "", :null => false
      t.column "cc_name",                    :string
      t.column "cc_address1",                :string
      t.column "cc_address2",                :string
      t.column "cc_postalcode",              :string,    :limit => 15
      t.column "cc_country",                 :string
      t.column "cc_city",                    :string,    :limit => 100
      t.column "cc_issue",                   :string,    :limit => 2
      t.column "cc_type",                    :string,    :limit => 25
      t.column "currency",                   :string,    :limit => 3
      t.column "cc_last_4_digits",           :string,    :limit => 25
      t.column "cc_expiry",                  :datetime
      t.column "vp_cross_reference",         :string,    :limit => 50
      t.column "audit_updated_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
      t.column "deleted",                    :integer,                  :default => 0,  :null => false
    end

    add_index "accounts", ["subdomain"], :name => "accounts_subdomain_index"
    add_index "accounts", ["primary_person_id"], :name => "accounts_primary_person_id_index"

    create_table "audit_accounts" do |t|
      t.column "type",             :string,   :limit => 20,  :default => "", :null => false
      t.column "subdomain",        :string,   :limit => 50,  :default => "", :null => false
      t.column "email",            :string,   :limit => 100, :default => "", :null => false
      t.column "plan",             :string,   :limit => 30,  :default => "", :null => false
      t.column "order_number",     :string,   :limit => 30
      t.column "domain",           :string,   :limit => 3,   :default => "", :null => false
      t.column "ip",               :string,   :limit => 20,  :default => "", :null => false
      t.column "cc_name",          :string,   :limit => 100
      t.column "cc_address1",      :string,   :limit => 100
      t.column "cc_address2",      :string,   :limit => 100
      t.column "cc_postalcode",    :string,   :limit => 20
      t.column "cc_city",          :string,   :limit => 100
      t.column "cc_country",       :string,   :limit => 100
      t.column "cc_type",          :string,   :limit => 100
      t.column "cc_last_4_digits", :string,   :limit => 4
      t.column "cc_expiry",        :string,   :limit => 5
      t.column "amount",           :float
      t.column "currency",         :string,   :limit => 3
      t.column "created_on",       :datetime
    end

    create_table "audit_logins" do |t|
      t.column "person_id",  :integer
      t.column "account_id", :integer
      t.column "subdomain",  :string,    :limit => 50
      t.column "username",   :string,    :limit => 30
      t.column "failed",     :boolean,                 :default => false, :null => false
      t.column "created_on", :timestamp
    end

    create_table "binaries" do |t|
      t.column "data",       :binary
      t.column "filesize",   :integer,   :default => 0, :null => false
      t.column "updated_on", :timestamp
      t.column "created_on", :timestamp
    end

    create_table "clients" do |t|
      t.column "account_id",                 :integer,                 :default => 0,  :null => false
      t.column "name",                       :string,                  :default => "", :null => false
      t.column "address1",                   :string,                  :default => "", :null => false
      t.column "address2",                   :string,                  :default => "", :null => false
      t.column "city",                       :string,                  :default => "", :null => false
      t.column "state",                      :string,                  :default => "", :null => false
      t.column "postalcode",                 :string,    :limit => 15, :default => "", :null => false
      t.column "country",                    :string,                  :default => "", :null => false
      t.column "web",                        :string,                  :default => "", :null => false
      t.column "tel",                        :string,    :limit => 30, :default => "", :null => false
      t.column "fax",                        :string,    :limit => 30, :default => "", :null => false
      t.column "vat_registration",           :string,    :limit => 50, :default => "", :null => false
      t.column "audit_created_by_person_id", :integer
      t.column "audit_updated_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    add_index "clients", ["account_id"], :name => "clients_account_id_index"

    create_table "credit_card_transactions" do |t|
      t.column "type",                   :string,   :limit => 50,  :default => "", :null => false
      t.column "account_id",             :integer,                 :default => 0,  :null => false
      t.column "subdomain",              :string,   :limit => 50,  :default => "", :null => false
      t.column "order_number",           :string,   :limit => 30
      t.column "cc_name",                :string,   :limit => 100
      t.column "cc_address1",            :string,   :limit => 100
      t.column "cc_address2",            :string,   :limit => 100
      t.column "cc_city",                :string,   :limit => 100
      t.column "cc_postalcode",          :string,   :limit => 20
      t.column "cc_country",             :string,   :limit => 100
      t.column "cc_type",                :string,   :limit => 100
      t.column "cc_last_4_digits",       :string,   :limit => 4
      t.column "cc_expiry",              :string,   :limit => 5
      t.column "currency",               :string,   :limit => 3
      t.column "vp_cross_reference",     :string,   :limit => 50
      t.column "vp_old_cross_reference", :string,   :limit => 50
      t.column "amount",                 :float
      t.column "created_on",             :datetime
    end

    create_table "currencies", :id => false do |t|
      t.column "code",    :string,  :limit => 3,  :default => "", :null => false
      t.column "name",    :string,  :limit => 50, :default => "", :null => false
      t.column "symbol",  :string,  :limit => 5,  :default => "", :null => false
      t.column "infront", :integer, :limit => 3,  :default => 1,  :null => false
    end

    add_index "currencies", ["code"], :name => "currencies_code_index"

    create_table "email_logs" do |t|
      t.column "email_type",                 :string,    :limit => 30,                                :default => "", :null => false
      t.column "account_id",                 :integer,                                                :default => 0,  :null => false
      t.column "invoice_id",                 :integer,                                                :default => 0,  :null => false
      t.column "client_id",                  :integer,                                                :default => 0,  :null => false
      t.column "to",                         :string,                                                 :default => "", :null => false
      t.column "from",                       :string,                                                 :default => "", :null => false
      t.column "sent_on",                    :datetime,                                                               :null => false
      t.column "amount_due",                 :decimal,                 :precision => 10, :scale => 2
      t.column "audit_created_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    create_table "images" do |t|
      t.column "account_id",                 :integer,                  :default => 0,  :null => false
      t.column "binary_id",                  :integer,                  :default => 0,  :null => false
      t.column "width",                      :integer,                  :default => 0,  :null => false
      t.column "height",                     :integer,                  :default => 0,  :null => false
      t.column "content_type",               :string,    :limit => 100, :default => "", :null => false
      t.column "original_filename",          :string,    :limit => 100, :default => "", :null => false
      t.column "original_filesize",          :integer,                  :default => 0,  :null => false
      t.column "audit_created_by_person_id", :integer,                  :default => 0
      t.column "audit_updated_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    add_index "images", ["account_id"], :name => "images_account_id_index"

    create_table "line_item_types" do |t|
      t.column "name",     :string
      t.column "position", :integer
    end

    create_table "invoice_lines" do |t|
      t.column "account_id",                 :integer,                                  :default => 0,   :null => false
      t.column "invoice_id",                 :integer,                                  :default => 0,   :null => false
      t.column "line_item_type_id",       :integer,                                  :default => 1,   :null => false
      t.column "price",                      :decimal,   :precision => 10, :scale => 2, :default => 0.0, :null => false
      t.column "quantity",                   :decimal,   :precision => 10, :scale => 2, :default => 1.0, :null => false
      t.column "description",                :string,                                   :default => "",  :null => false
      t.column "audit_updated_by_person_id", :integer
      t.column "audit_created_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    add_index "invoice_lines", ["invoice_id"], :name => "invoice_lines_invoice_id_index"

    create_table "invoice_templates" do |t|
      t.column "name",             :string,   :limit => 50, :default => "", :null => false
      t.column "type",             :string,   :limit => 50, :default => "", :null => false
      t.column "preview_filename", :string,   :limit => 50
      t.column "css_filename",     :string,   :limit => 50
      t.column "updated_on",       :datetime
      t.column "created_on",       :datetime
    end

    create_table "invoices" do |t|
      t.column "account_id",                 :integer,                                                :default => 0,          :null => false
      t.column "client_id",                  :integer,                                                :default => 0,          :null => false
      t.column "number",                     :string,    :limit => 30,                                :default => "",         :null => false
      t.column "po_number",                  :string,    :limit => 30,                                :default => "",         :null => false
      t.column "use_tax",                    :boolean,                                                :default => true,       :null => false
      t.column "tax_system",                 :string,    :limit => 30
      t.column "tax_percentage",             :decimal,                 :precision => 10, :scale => 2, :default => 0.0,        :null => false
      t.column "shipping",                   :decimal,                 :precision => 10, :scale => 2, :default => 0.0,        :null => false
      t.column "late_fee_percentage",        :decimal,                 :precision => 10, :scale => 2, :default => 0.0,        :null => false
      t.column "terms",                      :string,    :limit => 30,                                :default => "",         :null => false
      t.column "currency_id",                :string,    :limit => 3,                                 :default => "",         :null => false
      t.column "date",                       :date,                                                                           :null => false
      t.column "due_date",                   :date,                                                                           :null => false
      t.column "timezone",                   :string,    :limit => 50,                                :default => "Pretoria", :null => false
      t.column "status_id",                  :integer,                                                :default => 1,          :null => false
      t.column "subtotal",                   :decimal,                 :precision => 10, :scale => 2
      t.column "paid",                       :float,                                                  :default => 0.0,        :null => false
      t.column "audit_updated_by_person_id", :integer
      t.column "audit_created_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    add_index "invoices", ["account_id"], :name => "invoices_account_id_index"
    add_index "invoices", ["client_id"], :name => "invoices_client_id_index"

    create_table "payments" do |t|
      t.column "account_id",                 :integer,                                                :default => 0,   :null => false
      t.column "invoice_id",                 :integer,                                                :default => 0,   :null => false
      t.column "amount",                     :decimal,                 :precision => 10, :scale => 2, :default => 0.0, :null => false
      t.column "means",                      :string,    :limit => 30,                                :default => "",  :null => false
      t.column "reference",                  :string,    :limit => 30,                                :default => "",  :null => false
      t.column "date",                       :date,                                                                    :null => false
      t.column "audit_updated_by_person_id", :integer
      t.column "audit_created_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    add_index "payments", ["invoice_id"], :name => "payments_invoice_id_index"

    create_table "people" do |t|
      t.column "type",                       :string,    :limit => 20,  :default => "", :null => false
      t.column "account_id",                 :integer,                  :default => 0,  :null => false
      t.column "client_id",                  :integer
      t.column "firstname",                  :string,    :limit => 50,  :default => "", :null => false
      t.column "lastname",                   :string,    :limit => 100, :default => "", :null => false
      t.column "email",                      :string,                   :default => "", :null => false
      t.column "tel",                        :string,    :limit => 30,  :default => "", :null => false
      t.column "mobile",                     :string,    :limit => 30,  :default => "", :null => false
      t.column "username",                   :string,    :limit => 30
      t.column "salt",                       :string,    :limit => 40
      t.column "salted_password",            :string,    :limit => 40
      t.column "security_token",             :string,    :limit => 40
      t.column "token_expiry",               :datetime
      t.column "audit_updated_by_person_id", :integer
      t.column "audit_created_by_person_id", :integer
      t.column "created_on",                 :timestamp
      t.column "updated_on",                 :timestamp
    end

    add_index "people", ["account_id"], :name => "people_account_id_index"
    add_index "people", ["client_id"], :name => "people_client_id_index"

    create_table "plans" do |t|
      t.column "name",                          :string,  :limit => 20, :default => "",    :null => false
      t.column "special",                       :boolean,               :default => false, :null => false
      t.column "invoices",                      :integer,               :default => 0,     :null => false
      t.column "users",                         :integer,               :default => 0,     :null => false
      t.column "clients",                       :integer,               :default => 0,     :null => false
      t.column "allow_custom_css",              :boolean,               :default => false, :null => false
      t.column "unbranded_emails",              :boolean,               :default => false, :null => false
      t.column "print_css",                     :boolean,               :default => false, :null => false
      t.column "draft_invoices",                :boolean,               :default => false, :null => false
      t.column "invoice_templates",             :boolean,               :default => false, :null => false
      t.column "cost_for_za",                   :integer,               :default => 0,     :null => false
      t.column "display_cost_for_za",           :string,  :limit => 11, :default => "",    :null => false
      t.column "display_currency_cost_for_za",  :string,  :limit => 11, :default => "",    :null => false
      t.column "cost_for_com",                  :integer,               :default => 0,     :null => false
      t.column "display_cost_for_com",          :string,  :limit => 11, :default => "",    :null => false
      t.column "display_currency_cost_for_com", :string,  :limit => 11, :default => "",    :null => false
      t.column "cost_for_uk",                   :integer,               :default => 0,     :null => false
      t.column "display_cost_for_uk",           :string,  :limit => 11, :default => "",    :null => false
      t.column "display_currency_cost_for_uk",  :string,  :limit => 11, :default => "",    :null => false
      t.column "seq",                           :integer,               :default => 0,     :null => false
    end

    create_table "preferences" do |t|
      t.column "account_id",                 :integer,                                                :default => 0,          :null => false
      t.column "logo_image_id",              :integer,                                                :default => 0
      t.column "currency_id",                :string,    :limit => 3,                                 :default => "ZAR",      :null => false
      t.column "timezone",                   :string,    :limit => 50,                                :default => "Pretoria", :null => false
      t.column "tax_system",                 :string,    :limit => 30
      t.column "tax_percentage",             :decimal,                 :precision => 10, :scale => 2, :default => 14.0,       :null => false
      t.column "terms",                      :string,    :limit => 30,                                :default => "30 days",  :null => false
      t.column "invoice_template_id",        :integer,                                                :default => 1,          :null => false
      t.column "invoice_css",                :text
      t.column "thankyou_message",           :text,                                                   :default => "",         :null => false
      t.column "reminder_message",           :text,                                                   :default => "",         :null => false
      t.column "audit_updated_by_person_id", :integer
      t.column "updated_on",                 :timestamp
      t.column "created_on",                 :timestamp
    end

    add_index "preferences", ["account_id"], :name => "preferences_account_id_index"

    create_table "sessions" do |t|
      t.column "session_id", :string
      t.column "data",       :text
      t.column "updated_at", :datetime
    end

    add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

    create_table "status" do |t|
      t.column "name", :string, :limit => 11
    end

    create_table "taxes" do |t|
      t.column "name", :string, :limit => 30, :default => "", :null => false
    end

    create_table "terms" do |t|
      t.column "description", :string,  :limit => 100, :default => "", :null => false
      t.column "days",        :integer,                :default => 0,  :null => false
    end

  end
  
  def self.down
  end
end
