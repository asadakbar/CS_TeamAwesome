require "./user.rb"

module CraigslistCrawler
  module Interface
    def self.start
      puts "Welcome to the Craigslist scraper!"
      puts "Would you like to log in or create a new account? Type 'login' or 'new'."
      login_or_create = gets.chomp
      case login_or_create
      when "new"
        new_user
      when "login"
        login
      else
        raise "Sorry, that wasn't a valid option. See ya."
      end
      enter_search_terms
    end

    def self.new_user
      credentials = get_credentials
      @user = User.new(credentials[:email], credentials[:password])
      @user.save
    end

    def self.login
      credentials = get_credentials
      @user = User.authenticate(credentials[:email], credentials[:password])
    end

    def self.get_credentials
      puts "Enter your email address:"
      email = gets.chomp
      puts "Enter your password:"
      password = gets.chomp
      {:email => email, :password => password}
    end

    def self.enter_search_terms
      questions = {:location => "What location would you like? Please use the Craigslist code, e.g. 'sfbay'.",
                   :sub_region => "What sub-region would you like to search? e.g., 'sfc'.",
                   :section => "What section would you like to search? Currently, only housing sections are supported. e.g. 'hhh'.",
                   :query => "What terms would you like to search for?",
                   :bedrooms => "How many bedrooms would you like?",
                   :cat => "Is it okay to live with a cat? Please enter 'true' or 'false'.",
                   :dog => "What about a dog?",
                   :min_price => "What is your minimum price?",
                   :max_price => "What is your maximum price?"}
      search_options = {}

      questions.each do |key, question|
        puts question
        search_options[key] = gets.chomp
      end

      @user.search_options = search_options
    end

  end
end

CraigslistCrawler::Interface.start