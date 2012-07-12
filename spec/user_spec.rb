require "spec_helper"

describe User do

  before :each do
    File.read("db/schema.sql").split(";").each { |line| CraigslistCrawler.database.execute(line) }
    @test_user = User.new("orasaoneal@gmail.com", "password")
  end


  context "#initialize" do
    it "initializes a user with an email and password" do
      @test_user.should be_an_instance_of User
    end
    it "initializes with a search options hash as well" do
      User.new("foo@bar.com", "password").should be_an_instance_of User
    end

    it "initializes with an email options hash too!" do
      User.new("foo@bar.com", "password").should be_an_instance_of User
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
end