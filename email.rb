require 'rest-client'
require 'json'

module CraigslistCrawler
  class Message
    MAILGUN_API_KEY = "https://api:key-86cra9g7axoraovh5tt96int-0elozd5"
    MAILGUN_API_URL = "@api.mailgun.net/v2/craigslistcrawler.mailgun.org/messages"

    attr_reader :sent_at

    def initialize(message_options)
      message_options.each { |key, value| instance_variable_set("@#{key}", {key => value}) }
    end

    def send
      begin
        mailgun_response = RestClient.post("#{MAILGUN_API_KEY}#{MAILGUN_API_URL}", @to, @from, @subject, @text)
        JSON.parse(mailgun_response)
        @sent_at = Time.now
        :success
      rescue
        :failure
      end
    end

  end
end