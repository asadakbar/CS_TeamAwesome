require 'rspec'
require './message.rb'

include CraigslistCrawler

describe Message do
  MAILGUN_KEY = "key-86cra9g7axoraovh5tt96int-0elozd5"
  MAILGUN_ENDPOINT = "api.mailgun.net/v2/craigslistcrawler.mailgun.org/messages"
  MAILGUN_URL = "https://api:#{MAILGUN_KEY}@#{MAILGUN_ENDPOINT}"

  GOOD_MESSAGE_OPTIONS = {to: "test@test.com",
                          from: "from@from.com",
                          subject: "this is a test",
                          text: "this is only a test."}

  GOOD_MAILGUN_OPTIONS = [MAILGUN_URL,
                          {to: "test@test.com"},
                          {from: "from@from.com"},
                          {subject: "this is a test"},
                          {text: "this is only a test."}]

  BAD_MESSAGE_OPTIONS = {to: "test@bad_email",
                         from: "from",
                         subject: "this is a test",
                         text: "this is only a test."}

  BAD_MAILGUN_OPTIONS =  [MAILGUN_URL,
                          {to: "test@bad_email"},
                          {from: "from"},
                          {subject: "this is a test"},
                          {text: "this is only a test."}]

  MAILGUN_RESPONSE = {
                      "message" => "Queued. Thank you.",
                      "id" => "<20120710184516.15213.13391@craigslistcrawler.mailgun.org>"
                     }.to_json


  let(:test_message) { Message.new(GOOD_MESSAGE_OPTIONS) }

  context "#initialize" do
    it "initializes a new email with an options hash" do
      test_message.should be_an_instance_of Message
    end
  end

  context "#send!" do
    it "returns :success if it successfully sends the email" do
      RestClient.should_receive(:post).with(*GOOD_MAILGUN_OPTIONS).and_return(MAILGUN_RESPONSE)
      test_message.send!.should eq(:success)
    end

    it "returns :failure if it can't send the email" do
      @bad_message = Message.new(BAD_MESSAGE_OPTIONS)
      RestClient.should_receive(:post).with(*BAD_MAILGUN_OPTIONS).and_raise(RestClient::BadRequest)
      @bad_message.send!.should eq(:failure)
    end
  end

  context "#sent_at" do
    it "returns the time the email was sent" do
      RestClient.should_receive(:post).with(*GOOD_MAILGUN_OPTIONS).and_return(MAILGUN_RESPONSE)
      Time.stub(:now).and_return(Time.now)

      test_message.send!
      test_message.sent_at.should eq Time.now
    end
  end
end