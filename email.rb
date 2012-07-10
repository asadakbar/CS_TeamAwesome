require 'rest-client'

module CraigslistCrawler

  class Email
    def initialize(email_options)
    end

    def send
      RestClient.post
    end
  end

end