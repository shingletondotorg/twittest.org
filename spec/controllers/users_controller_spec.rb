require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    before(:each) do
      get 'new'
    end
    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title', :content => "Sign up")
    end

    it "should have a name field" do
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    it "should have an email field" do
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it "should have a password field" do
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    it "should have a password field" do
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end # GET new

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar 1")
      mp2 = Factory(:micropost, :user => @user, :content => "Foo bar 2")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end

    it "should paginate the user's microposts" do
      @microposts = []
      99.times do
        @microposts << Factory(:micropost , :user => @user)
      end
      get :show, :id => @user
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/users/1?page=2",
                                    :content => "2")
      response.should have_selector("a", :href => "/users/1?page=2",
                                    :content => "Next")
    end

    it "should show delete links for the signed-in user's posts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar 1")
      mp2 = Factory(:micropost, :user => @user, :content => "Foo bar 2")
      test_sign_in(@user)
      get :show, :id => @user
      response.should have_selector('td > a[data-method="delete"]',
                                    :content => "delete")
    end

    it "should not show delete links for another user's posts" do
      other_user = Factory(:user, :email => Factory.next(:email))
      mp1 = Factory(:micropost, :user => other_user, :content => "Foobar 1")
      mp2 = Factory(:micropost, :user => other_user, :content => "Foobar 2")
      test_sign_in(@user)
      get :show, :id => other_user
      response.should_not have_selector('td > a[data-method="delete"]',
                                        :content => "delete")
    end
  end # GET 'show'

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "",
                  :email => "",
                  :password => "",
                  :password_confirmation => ""}
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should clear the password field" do
        # Set a non-empty password so we can check that it was cleared
        hash = @attr.merge({:password => 'foobar',
                           :password_confirmation => 'foobar'})
        post :create, :user => hash
        # :value => "" ensures that the field is empty (like /^$/).
        # :content => "" does not; it will match anything (like //).
        response.should have_selector("input[name='user[password]']",
                                      :value => "")
      end
    end # failure

    describe "success" do
      before(:each) do
        @attr = {
          :name => "New User",
          :email => "user@example.com",
          :password => "foo bar baz",
          :password_confirmation => "foo bar baz"
        }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Welcome to the sample app/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end # success
  end # POST 'create'

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      get :edit, :id => @user
    end
    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end # GET 'edit'

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @invalid_attr = { :email => "", :name => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @invalid_attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @invalid_attr
        response.should have_selector("title", :content => "Edit user")
      end
    end # failure

    describe "success" do
      before(:each) do
        @attr = { :name => "New Name",
                  :email => "user@example.org",
                  :password => "foobarbaz",
                  :password_confirmation => "foobarbaz" }
      end

      it "should change the user's attribute" do
        put :update, :id => @user, :user => @attr
        user = assigns(:user)
        @user.reload
        @user.name.should  == user.name
        @user.email.should == user.email
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end # success
  end # PUT "update"

  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        get :update, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        get :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end # authentication for edit/update

  describe "GET 'index'" do
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end
    end # signed-in users
  end # GET 'index'

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com",
                        :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end # as an admin user
  end # DELETE 'destroy'
end
