require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @conference = FactoryGirl.create(:conference)
    @person = FactoryGirl.create(:person)
    @user = FactoryGirl.create(:user, person: FactoryGirl.create(:person))
    login_as(:admin)
  end

  test "should get new" do
    get :new, person_id: @person.id, conference_acronym: @conference.acronym
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: FactoryGirl.build(:user).attributes.merge(password: "frab123", password_confirmation: "frab123"), person_id: @person.id, conference_acronym: @conference.acronym
    end

    assert_redirected_to person_user_path(@person)
  end

  test "should get edit" do
    get :edit, person_id: @user.person.id, conference_acronym: @conference.acronym
    assert_response :success
  end

  test "should update user" do
    put :update, user: @user.attributes, person_id: @user.person.id, conference_acronym: @conference.acronym
    assert_redirected_to person_user_path(@user.person)
  end

  test "should create crew user" do
    assert_difference('User.count') do
      post :create, 
        user: FactoryGirl.build(:crew_user).attributes.merge(password: "frab123", password_confirmation: "frab123"), 
        person_id: @person.id, 
        conference_acronym: @conference.acronym
    end
  end

  test "should change users role" do
    @user.role = 'crew'
    put :update, user: @user.attributes, person_id: @user.person.id, conference_acronym: @conference.acronym
    @user.reload
    assert_equal 'crew', @user.role
  end

  test "should add conference user to existing crew user" do
    @user = FactoryGirl.create(:crew_user, person: FactoryGirl.create(:person))
    user_attributes = @user.attributes
    user_attributes["conference_users_attributes"] = { 
      '0' => FactoryGirl.attributes_for(:conference_user, role: "reviewer", conference_id: @conference.id)
    }
    assert_difference('ConferenceUser.count') do
      put :update,
        user: user_attributes,
        person_id: @user.person.id,
        conference_acronym: @conference.acronym
    end
    assert_redirected_to person_user_path(@user.person)
  end

end
