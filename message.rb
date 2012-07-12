require 'rest-client'
require 'json'

module CraigslistCrawler
  class Message
    MAILGUN_KEY = "key-86cra9g7axoraovh5tt96int-0elozd5"
    MAILGUN_ENDPOINT = "api.mailgun.net/v2/craigslistcrawler.mailgun.org/messages"
    MAILGUN_URL = "https://api:#{MAILGUN_KEY}@#{MAILGUN_ENDPOINT}"

    attr_reader :sent_at

    def initialize(message_options)
      message_options.each { |key, value| instance_variable_set("@#{key}", {key => value}) }
    end

    def send!
      begin
        RestClient.post("#{MAILGUN_URL}", @to, @from, @subject, @text)
        @sent_at = Time.now
        # @sent_at
        :success
      rescue
        :failure
      end
    end

  end
end