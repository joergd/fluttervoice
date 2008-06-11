require 'yaml'

class BlogHeadline
  attr_accessor :id, :title, :url
 
  def initialize(id, title, url)
    @id = id
    @title = title
    @url = url
  end
  
  def self.get
    headline_yaml = YAML::load(File.open("#{RAILS_ROOT}/public/blog/headline.yml"))
    if headline_yaml
      self.new(headline_yaml['id'], headline_yaml['title'], "#{headline_yaml['url']}")
    else
      return nil
    end
  end
end
