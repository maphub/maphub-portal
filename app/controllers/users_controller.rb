class UsersController < ApplicationController
    
    # GET /users
    def index
      @users = User.all
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    end
  
    # GET /users/1
    # GET /users/1.xml
    def show
      @user = User.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
    
    # Deactivates the user and logs them out
    def deactivate
      
      @user = User.find(params[:id])
      
      if @user.id != current_user.id
        redirect_to home_index_path, :notice => "You are not allowed to do that"
        return
      end
      
      @user.deactivate
      
      respond_to do |format|
         format.html { redirect_to destroy_user_session_path, :notice => "Your account was deleted!" }
      end
      
    end
  
end