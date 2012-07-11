require "rspec"
require "./helpers.rb"
require "./user.rb"

include CraigslistCrawler

describe User do
  TEST_SEARCH_OPTIONS = {:location => 'sfbay',
                         :section => 'hhh',
                         :query => 'victorian',
                         :bedrooms => 2,
                         :cat => true,
                         :dog => true,
                         :min_price => 1800,
                         :max_price => 2600,
                         :sub_region => 'sfc'}
  TEST_EMAIL_OPTIONS = {:subject => 'I wanna live with you.',
                        :body => 'I\'m not creepy, I promise.'}

  before :each do
    @db = SQLite3::Database.new "test.db"
    @db.execute("DROP TABLE IF EXISTS USERS")
    @db.execute("CREATE TABLE users ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                                      email VARCHAR NOT NULL,
                                      password VARCHAR NOT NULL
                                     );")
    @test_user = User.new("orasaoneal@gmail.com", "password", nil, nil, "test.db")
  end

  context "#initialize" do
    it "initializes a user with an email and password" do
      @test_user.should be_an_instance_of User
    end
    it "initializes with a search options hash as well" do
      User.new("foo@bar.com", "password", {:location => 'sfbay'}).should be_an_instance_of User
    end

    it "initializes with an email options hash too!" do
      User.new("foo@bar.com", "password", {:location => 'sfbay'}, {:subject => 'pick me pick me'}).should be_an_instance_of User
    end
  end

  context "#self.authenticate" do
    it "returns the user object if the email and password exist" do
      @test_user.save
      User.authenticate("orasaoneal@gmail.com", "password").should be_an_instance_of User
    end

    it "raises an error if the email and password don't exist" do
      lambda { User.authenticate("does_not_exist@example.com", "foobar") }.should raise_error
    end
  end

  context "#save" do
    it "saves the user to the database" do
      @test_user.save
      User.authenticate("orasaoneal@gmail.com", "password").should be_an_instance_of User
    end

    it "give an error when the email already taken" do
      @test_user2 = @test_user.dup
      @test_user.save
      lambda { @test_user2.save }.should raise_error
    end
  end

  context "#search_options" do
    it "updates an existing user with new search options" do
      @test_user.search_options = TEST_SEARCH_OPTIONS
      @test_user.search_options.should eq TEST_SEARCH_OPTIONS
    end
  end

  context "#email_options" do
    it "updates an existing user with an email subject and body" do
      @test_user.email_options = TEST_EMAIL_OPTIONS
      @test_user.email_options.should eq TEST_EMAIL_OPTIONS
    end
  end
end