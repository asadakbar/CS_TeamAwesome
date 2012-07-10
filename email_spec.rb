require 'rspec'
require './email.rb'

include CraigslistCrawler

describe Email do
  EMAIL_OPTIONS = {:to => "test@test.com",
                   :from => "from@from.com",
                   :subject => "this is a test",
                   :body => "this is only a test."}

  context "#initialize" do
    it "initializes a new email with an options hash" do
      @email = Email.new(EMAIL_OPTIONS)
      @email.should be_an_instance_of Email
    end
  end

  context "#send" do
    it "send email with email_options" do
      # my_mock = double("whatever")
      # my_mock.stub(:email).and_return(EMAIL_OPTIONS)
      # p my_mock.email
      #  @email.send.should_receive() # send an email to the address i told it to, from the email i said, with the subject i said, with the body i said

      rest_mock = double(RestClient)
      rest_mock.stub(:post)
    end
  end

end