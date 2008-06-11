class CreateInvoiceTemplates < ActiveRecord::Migration
  def self.up
    SystemInvoiceTemplate.create(:name => "Fluttervoice",
                                  :preview_filename => "fluttervoice.jpg",
                                  :css_filename => "fluttervoice.css" )

    SystemInvoiceTemplate.create(:name => "Holiday Memory",
                                  :preview_filename => "holiday_memory.jpg",
                                  :css_filename => "holiday_memory.css" )

    SystemInvoiceTemplate.create(:name => "Sunburnt Daughters",
                                  :preview_filename => "sunburnt_daughters.jpg",
                                  :css_filename => "sunburnt_daughters.css" )

    SystemInvoiceTemplate.create(:name => "A Slap of Sea",
                                  :preview_filename => "a_slap_of_sea.jpg",
                                  :css_filename => "a_slap_of_sea.css" )

    SystemInvoiceTemplate.create(:name => "Sandy Sandwiches",
                                  :preview_filename => "sandy_sandwiches.jpg",
                                  :css_filename => "sandy_sandwiches.css" )

    SystemInvoiceTemplate.create(:name => "Faded Umbrella",
                                  :preview_filename => "faded_umbrella.jpg",
                                  :css_filename => "faded_umbrella.css" )

    SystemInvoiceTemplate.create(:name => "Sticky Sweet",
                                  :preview_filename => "sticky_sweet.jpg",
                                  :css_filename => "sticky_sweet.css" )

    SystemInvoiceTemplate.create(:name => "Fleeting Castles",
                                  :preview_filename => "fleeting_castles.jpg",
                                  :css_filename => "fleeting_castles.css" )

    SystemInvoiceTemplate.create(:name => "Grass Burns",
                                  :preview_filename => "grass_burns.jpg",
                                  :css_filename => "grass_burns.css" )

    SystemInvoiceTemplate.create(:name => "Black and White",
                                  :preview_filename => "black_and_white.jpg",
                                  :css_filename => "black_and_white.css" )

  end

  def self.down
    SystemInvoiceTemplate.delete_all
  end
end
