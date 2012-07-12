require 'rest-client'
require 'json'

module CraigslistCrawler
  class Message
    MAILGUN_KEY = "key-86cra9g7axoraovh5tt96int-0elozd5"
    MAILGUN_ENDPOINT = "api.mailgun.net/v2/craigslistcrawler.mailgun.org/messages"
    MAILGUN_URL = "https://api:#{MAILGUN_KEY}@#{MAILGUN_ENDPOINT}"

    attr_reader :sent_at

    def initialize(user, listing, template)
      @to = {to: listing.email}
      @from = {from: user.email}
      @subject = {subject: listing.title}
      @text = {text: template.text}
      @user_id = user.id
      @message_template_id = template.id
    end

    def send!
      begin
        RestClient.post("#{MAILGUN_URL}", @to, @from, @subject, @text)
        @sent_at = Time.now
        :success
      rescue
        :failure
      end
    end

    def save
      CraigslistCrawler.database.execute("INSERT INTO messages ('sent_at', 'user_id', 'message_template_id')
                                          VALUES ('#{@sent_at}', '#{@user_id}', '#{@message_template_id}')")
    end
  end
end