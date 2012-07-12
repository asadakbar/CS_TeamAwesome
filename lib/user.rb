module CraigslistCrawler
  class User
    def initialize(email, password)
      @email = email
      @password = password
    end

    def save
      if duplicate?
         raise "That email is already taken."
      else
        CraigslistCrawler.database.execute("insert into users ('email', 'password')
                                            values ('#{@email}', '#{@password}')")
      end
    end

    def self.authenticate(email, password)
      user_array = CraigslistCrawler.database.execute("select * from users
                                                       where email = '#{email}' and password = '#{password}'")
      if user_array.length == 0
        raise "There's no user with that email and password."
      else
        User.new(user_array[0][1], user_array[0][2])
      end
    end

    private

    def duplicate?
      CraigslistCrawler.database.execute("select * from users
                                          where email like '#{@email}'")[0]
    end
  end
end