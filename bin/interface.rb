require "lib/helpers.rb"

module CraigslistCrawler
  module Interface
    def self.start
      puts "Welcome to the Craigslist scraper!"
      puts "Would you like to log in or create a new account? Type 'login' or 'new'."
      login_or_create = gets.chomp
        case login_or_create
        when "new"
          new_user
          get_crawler_options
          get_template
        when "login"
          login
          Crawler.from_db(@user)
          Template.from_db(@user)
        else
          raise "Sorry, that wasn't a valid option. See ya."
        end

      loop do
        puts "Searching for your terms..."
        get_new_listings
        puts "Sending messages..."
        send_messages
        puts "Waiting an hour before trying again..."
        sleep 3_600
      end
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

    def self.get_crawler_options
      questions = {:location => "What location would you like? Please use the Craigslist code, e.g. 'sfbay'.",
                   :sub_region => "What sub-region would you like to search? e.g., 'sfc'.",
                   :section => "What section would you like to search? Currently, only housing sections are supported. e.g. 'hhh'.",
                   :query => "What terms would you like to search for?",
                   :bedrooms => "How many bedrooms would you like?",
                   :cat => "Is it okay to live with a cat? Please enter 'true' or 'false'.",
                   :dog => "What about a dog?",
                   :min_price => "What is your minimum price?",
                   :max_price => "What is your maximum price?"}

      crawler_options = {}

      questions.each do |key, question|
        puts question
        crawler_options[key] = gets.chomp
      end

      @crawler = Crawler.new(crawler_options)
    end

    def self.get_template
      puts "Please type in the message you'd like to send to listings matching your search:"
      template_text = gets.chomp
      @template = Template.new(text)
      @template.save
    end

    def self.crawl
      # run the crawler
    end

    def self.get_new_listings
      @listings = @crawler.listings
    end

    def self.send_messagess
      @listings.each do |listing|
        message = Message.new(@user, listing, @template)
        message.send!
        message.save
      end
    end

  end
end

CraigslistCrawler::Interface.start