module CraigslistCrawler
  class Listing
    attr_reader :title, :craigslist_id, :email, :user_id, :id

    def initialize(options = {})
      @title = options.fetch(:title) { raise ArgumentError.new("The listing must have a title.") }
      @craigslist_id = options.fetch(:craigslist_id) { raise ArgumentError.new("The listing must have a craigslist id.") }
      @email = options.fetch(:email) { raise ArgumentError.new("The listing must have an email.") }
      @user_id = options.fetch(:user_id) { raise ArgumentError.new("The listing must have a user id.") }
    end

    def save!
      CraigslistCrawler.database.execute("INSERT INTO listings ('title', 'craigslist_id', 'email', 'user_id')
                                          VALUES ('#{@title}', '#{@craigslist_id}', '#{@email}', '#{@user_id}')")
      @id = CraigslistCrawler.database.last_insert_row_id
    end
  end
end