require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid signup info' do
    get signup_path

    # asserts count is same before and after executing the block
    assert_no_difference 'User.count' do
      post users_path,  {
        user: {
          name:                   "ali",
          email:                  "ali@invalid",
          password:               "foo",
          password_confirmation:  "bar"
        }
      }
    end
    assert_template 'users/new'
  end

  test 'valid signup information' do
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, {
        user: {
          name:                   "amir esk",
          email:                  "amie@ail.com",
          password:               "asdfasdf",
          password_confirmation:  "asdfasdf"
        }
      }

    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
