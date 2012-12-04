require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User model has all Devise fields" do
    assert_nothing_raised do
      begin
        Devise::Models.check_fields!(User)
      rescue 
        print "Missing: " + $!.message
      end
    end
  end
end
