require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "example@example.com"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should require a name" do 
    noname_user = User.new(@valid_attributes.merge(:name => ""))
    noname_user.should_not be_valid
  end
  
  it "should require an email" do
    nomail_user = User.new(@valid_attributes.merge(:email => ""))
    nomail_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@valid_attributes.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@valid_attributes.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@valid_attributes.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it 'should reject duplicate email addresses identical up to case' do
    upcased_email = @valid_attributes[:email].upcase
    User.create!(@valid_attributes.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@valid_attributes)
    user_with_duplicate_email.should_not be_valid
  end
end
