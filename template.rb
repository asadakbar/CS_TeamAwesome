module CraigslistCrawler

  attr_accessor :text

  class Template
    def initialize(text)
      @text = text
    end
  end
end