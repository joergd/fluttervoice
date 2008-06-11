require 'RMagick'

class Image < ActiveRecord::Base
  belongs_to   :binary
  
  belongs_to   :account
  
  before_save     :save_data_to_binary_table
  before_destroy  :destroy_binary
    
  validates_presence_of   :original_filename, :content_type
  validates_format_of     :content_type,
                          :with => /image/,
                          :message => "you can only upload image files"

  @data = nil
  
  def initialize(attributes = nil)
    super
  end
  
  def logo_file=(incoming_file)
    if incoming_file

      self.original_filename = incoming_file.original_filename
      self.content_type = incoming_file.content_type
      @data = nil
      
      if valid?
        img = Magick::Image.read_inline(Base64.encode64(incoming_file.read)).first
        if valid_image_format?(img)
          self.original_filesize = img.filesize
          img = resize(img) if img.columns > 200 || img.rows > 200
          get_image_attributes(img)
          if valid_image_attributes?
            img.format = "GIF"
            @data = img.to_blob
          end
        end
      end
    end
  end
  
  def original_filename=(new_file_name)
    write_attribute("original_filename", sanitize_filename(new_file_name)) # don't use self. -> recursive
  end
  
private

  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all non-alphanumeric, dashes or periods with underscores
    just_filename.gsub(/[^\w\.\-]/,'_') 
  end

  def valid_image_format?(img)
    unless !img.nil? && ['JPEG', 'PNG', 'GIF', 'JPG'].include?(img.format)
      errors.add(:content_type, "is not a JPG, PNG, or GIF file")
      false
    else
      true
    end
  end
  
  def get_image_attributes(img)
    self.width = img.columns
    self.height = img.rows
  end

  def valid_image_attributes?
    unless self.width > 0 && self.height > 0
      errors.add(:content_type, "is not a JPG, PNG, or GIF file with valid height, or width")
      false
    else
      true
    end
  end

  def resize(img)
    img.change_geometry!("200x200") { |cols, rows, i|
      i.resize!(cols, rows)
    }  
  end
  
  def save_data_to_binary_table
    begin
      binary = Binary.find(self.binary_id)
    rescue
      binary = Binary.new
    end
    binary.data = @data
    binary.filesize = @data.size # disclaimer: no idea what it is actually measuring, but good to compare relative size 
    if binary.save
      self.binary_id = binary.id
    else
      self.errors.add_to_base "There was a problem saving your logo - we must be experiencing some difficulties - please try again later."
      false
    end    
  end

  def destroy_binary
    Binary.find(self.binary_id).destroy
  end
    
end
