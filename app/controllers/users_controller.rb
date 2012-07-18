class UsersController < ApplicationController
    
    before_filter :authenticate_user!, :except => [:show, :index]
    
    # GET /users
    def index
      @users = User.all
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
        format.json { render :json => @users }
      end
    end
  
    # GET /users/1
    # GET /users/1.xml
    def show
      @user = User.find(params[:id])
      unless current_user.nil?
        @myself = (current_user.id == @user.id) ? true : false
      end
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
    
    # Updates the user's description
    def update
      @user = User.find(params[:id])
      @user.update_attributes params[:user]
      
      # automatically responds with update.js.erb
    end
    
    # Deactivates the user and logs them out
    def deactivate
      
      @user = User.find(params[:id])
      unless current_user.nil?
        @myself = (current_user.id == @user.id) ? true : false
      end
      if not @myself
        redirect_to home_index_path, :notice => "You are not allowed to do that"
        return
      end
      
      @user.deactivate
      
      respond_to do |format|
         format.html { redirect_to destroy_user_session_path, :notice => "Your account was successfully deleted! Sad to see you go." }
      end
      
    end
  
end