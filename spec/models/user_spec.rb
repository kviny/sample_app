require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "example@example.com",
      :password => "foobar",
      :password_confirmation => 'foobar'
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
  
  it 'should require a password' do
    User.new(@valid_attributes.merge(:password => '', 
             :password_confirmation => '')).
    should_not be_valid
  end
  
  it 'should require a matching password confirmation' do
    User.new(@valid_attributes.merge(:password_confirmation => 'invalid')).
    should_not be_valid
  end
  
  it 'should reject short passwords' do
    short = "a" * 5
    User.new(@valid_attributes.merge(:password => short, 
             :password_confirmation => short)).
    should_not be_valid
  end
  
  it 'should reject long passwords' do
    long = "a" * 41
    User.new(@valid_attributes.merge(:password => long, 
             :password_confirmation => long)).
    should_not be_valid
  end
  
  describe 'password encryption' do
    before(:each) do
      @user = User.create!(@valid_attributes)
    end
    
    it 'should have an encrypted password attribute' do
      @user.should respond_to(:encrypted_password)
    end
    
    it 'should set an encrypted password' do
      @user.encrypted_password.should_not be_blank
    end
    
    describe 'has password? method' do
      it 'should be true if the passwords match' do
        @user.has_password?(@valid_attributes[:password]).should be_true
      end
      
      it 'should be false if the passwords mismatch' do
        @user.has_password?('invalid').should be_false
      end
    end
    
    describe 'authenticate method' do
      it 'should return nil on email/password mismatch' do
        wrong_password_user = User.authenticate(@valid_attributes[:email], 
                                                'wrongpass')
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", 
                                             @valid_attributes[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@valid_attributes[:email], 
                                          @valid_attributes[:password])
        matching_user.should == @user
      end
    end
  end
end
