require 'rexml/document'

# SimpleXML like xml parser. Written by leon breet from the ruby on rails 
# Mailing list
class XmlNode
  attr :node

  def initialize(node, options = nil)
    @node = node
    @children = {}
    options ||= {}
    @raise_errors = options[:raise_errors]
  end

  def self.from_xml(xml_or_io)
    XmlNode.new(REXML::Document.new(xml_or_io))
  end

  def encoding
    @node.encoding
  end

  def name
    @node.name
  end

  def value
    @node.text
  end
  alias :text :value

  def value=(value)
    @node.text = value
  end

  def xpath(expr)
    matches = nil
    REXML::XPath.each(@node, expr) do |element|
      matches ||= XmlNodeList.new
      matches << (@children[element] ||= XmlNode.new(element))
    end
    matches
  end

  def method_missing(name, *args)
    name = name.to_s
    nodes = nil
    @node.each_element(name) do |element|
      nodes ||= XmlNodeList.new
      nodes << (@children[element] ||= XmlNode.new(element))
    end
    nodes
  end

  def <<(node)
    if node.is_a? REXML::Node
      child = node
    elsif node.respond_to? :node
      child = node.node
    end
    @node.add_element child
    @children[child] ||= XmlNode.new(child)
  end

  def [](name)
    @node.attributes[name.to_s]
  end

  def []=(name, value)
    @node.attributes[name.to_s] = value
  end

  def to_s
    @node.to_s
  end

  def to_i
    to_s.to_i
  end
end

class XmlNodeList < Array
  def [](i)
    i.is_a?(String) ? super(0)[i] : super(i)
  end

  def []=(i, value)
    i.is_a?(String) ? self[0][i] = value : super(i, value)
  end

  def method_missing(name, *args)
    name = name.to_s
    self[0].__send__(name, *args)
  end
end