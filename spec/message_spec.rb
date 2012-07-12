require 'spec_helper'

describe Message do
  MAILGUN_KEY = "key-86cra9g7axoraovh5tt96int-0elozd5"
  MAILGUN_ENDPOINT = "api.mailgun.net/v2/craigslistcrawler.mailgun.org/messages"
  MAILGUN_URL = "https://api:#{MAILGUN_KEY}@#{MAILGUN_ENDPOINT}"

  GOOD_MAILGUN_OPTIONS = [MAILGUN_URL,
                          {to: "test@test.com"},
                          {from: "from@from.com"},
                          {subject: "this is a test"},
                          {text: "this is only a test."}]

  BAD_MAILGUN_OPTIONS =  [MAILGUN_URL,
                          {to: "test@bad_email"},
                          {from: "from"},
                          {subject: "this is a test"},
                          {text: "this is only a test."}]

  MAILGUN_RESPONSE = {
                      "message" => "Queued. Thank you.",
                      "id" => "<20120710184516.15213.13391@craigslistcrawler.mailgun.org>"
                     }.to_json


  let(:test_message) do
    test_user = User.new("from@from.com", "password")
    test_listing = Listing.new({:title => "this is a test",
                                :craigslist_id => 3135223890,
                                :email => "test@test.com",
                                :user_id => 1})
    test_template = Template.new("this is only a test.")
    Message.new(test_user, test_listing, test_template)
  end

  let(:bad_message) do
    bad_user = User.new("from", "password")
    bad_listing = Listing.new({:title => "this is a test",
                                :craigslist_id => 3135223890,
                                :email => "test@bad_email",
                                :user_id => 1})
    bad_template = Template.new("this is only a test.")
    Message.new(bad_user, bad_listing, bad_template)
  end

  before :each do
    File.read("db/schema.sql").split(";").each { |line| CraigslistCrawler.database.execute(line) }
  end

  context "#initialize" do
    it "initializes a new email with user, listing, and message_template objects" do
      test_message.should be_an_instance_of Message
    end
  end

  context "#send!" do
    it "returns :success if it successfully sends the email" do
      RestClient.should_receive(:post).with(*GOOD_MAILGUN_OPTIONS).and_return(MAILGUN_RESPONSE)
      test_message.send!.should eq(:success)
    end

    it "returns :failure if it can't send the email" do
      RestClient.should_receive(:post).with(*BAD_MAILGUN_OPTIONS).and_raise(RestClient::BadRequest)
      bad_message.send!.should eq(:failure)
    end
  end

  context "#sent_at" do
    it "returns the time the email was sent" do
      RestClient.should_receive(:post).with(*GOOD_MAILGUN_OPTIONS).and_return(MAILGUN_RESPONSE)
      time = Time.now
      Time.stub(:now).and_return(time)
      test_message.send!
      test_message.sent_at.should eq time
      test_message.sent_at.should_not be_nil
    end
  end

  context "#save" do
    it "should return the database id for the message" do
      lambda {test_message.save}.should_not raise_error
    end
  end
end