 require 'sqlite3'

module CraigslistCrawler
  class Listing
    include CraigslistCrawler

    attr_reader :title, :craigslist_id, :email, :user_id,:id

    def initialize(options = {}, db_file_name = 'crawler.db')
      @title = options.fetch(:title) { raise ArgumentError.new("The listing must have a title.") }
      @craigslist_id = options.fetch(:craigslist_id) { raise ArgumentError.new("The listing must have a craigslist id.") }
      @email = options.fetch(:email) { raise ArgumentError.new("The listing must have an email.") }
      @user_id = options.fetch(:user_id) { raise ArgumentError.new("The listing must have a user id.") }
      @id = nil
      @db_file_name = db_file_name
    end

    def save!
      db = CraigslistCrawler.db(@db_file_name)
      sql = "INSERT INTO listings ('title', 'craigslist_id', 'email', 'user_id') VALUES ('#{@title}', '#{@craigslist_id}', '#{@email}', '#{@user_id}')"
      db.execute(sql)
      @id = db.last_insert_row_id
    end


  end
end