class Name
  attr_reader :first, :last

  def initialize(first, last)
    @first = first
    @last = last
  end

  def to_s
    [ @first, @last ].compact.join(" ")
  end
  
  def official
    self.to_s if @last.empty?
    f = [ @first ].compact.join(" ")
    f.empty? ? @last : "#{@last}, #{f}"
  end
end