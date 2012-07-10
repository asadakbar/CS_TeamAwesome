 module CraigslistCrawler
  class Listing

    def initialize(options)
      @title = options.fetch(:title) { raise ArgumentError.new("The listing must have a title.") }
      @craigslist_id = options.fetch(:craigslist_id) { raise ArgumentError.new("The listing must have a craigslist id.") }
      @email = options.fetch(:email) { raise ArgumentError.new("The listing must have an email.") }
      @contacted_at = options.fetch(:contacted_at) { nil }
    end

    def contacted?
      !@contacted_at.nil?
    end
  end
end