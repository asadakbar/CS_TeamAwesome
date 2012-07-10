require "sqlite3"

module CraigslistCrawler
  class User
    attr_accessor :search_options, :email_options

    def initialize(email, password, search_options = {}, email_options = {})
      @email = email
      @password = password
      @search_options = search_options
      @email_options = email_options
      @db = SQLite3::Database.new "crawler.db"
    end

    def save
      if duplicate?
         raise "That email is already taken."
      else
        @db.execute("insert into users ('email', 'password') values ('#{@email}', '#{@password}')")
      end
    end

    def self.authenticate(email, password)
      @db = SQLite3::Database.new "crawler.db"
      user_array = @db.execute("select * from users where email = '#{email}' and password = '#{password}'")
      if user_array.length == 0
        raise "There's no user with that email and password."
      else
        User.new(user_array[0][1], user_array[0][2])
      end
    end

    private

    def duplicate?
      @db.execute("select * from users where email like '#{@email}'")[0]
    end
  end
end