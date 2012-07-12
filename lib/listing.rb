module CraigslistCrawler
  class Listing
    include CraigslistCrawler

    attr_reader :title, :craigslist_id, :email, :user_id,:id

    def initialize(options = {})
      @title = options.fetch(:title) { raise ArgumentError.new("The listing must have a title.") }
      @craigslist_id = options.fetch(:craigslist_id) { raise ArgumentError.new("The listing must have a craigslist id.") }
      @email = options.fetch(:email) { raise ArgumentError.new("The listing must have an email.") }
      @user_id = options.fetch(:user_id) { raise ArgumentError.new("The listing must have a user id.") }
      @id = nil
    end

    def save!
      CraigslistCrawler.database.execute("INSERT INTO listings ('title', 'craigslist_id', 'email', 'user_id')
                                          VALUES ('#{@title}', '#{@craigslist_id}', '#{@email}', '#{@user_id}')")
      @id = CraigslistCrawler.database.last_insert_row_id
    end



  end
end

# example = CraigslistCrawler::Listing.new(:title => "$62000 / 2br - Great house!",
#                          :craigslist_id => 3071972480,
#                          :email => 'vwdzk-3071972480@hous.craigslist.org',
#                          :user_id => 1)
# puts example
