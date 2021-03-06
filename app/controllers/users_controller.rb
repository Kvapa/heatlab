# coding: utf-8
class UsersController < ApplicationController
  before_filter :authorize
  before_filter :authorize_admin, :except => [:edit, :update]
  # GET /users
  # GET /users.json

  def index
    
    @users = User.where("worktype = 0").where("active = true").order('surname ASC')
    @users_ex = User.where("worktype = 1").where("active = true").order('surname ASC')

    @users_inact = User.where("active = false").order('surname ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
      @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Uživatel byl úspěšně vytvořen.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if params[:user][:retire] == ""
      params[:user][:retire] = nil
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        if admin?
          if !session[:previous_url].nil?
            format.html { redirect_to session[:previous_url] }
          else
            format.html { redirect_to users_path, notice: 'Údaje o uživateli byly úspěšně změněny.' }
          end
        else
          format.html { redirect_to edit_user_path(@user), notice: 'Údaje o uživateli byly úspěšně změněny.' }
        end

        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def vyhlaska
    @users = User.where("decree50 IS NOT NULL").order('surname ASC') 
    @users2 = User.where("decree50 IS NULL").order('surname ASC') 
  end 

  def smlouva
    @users = User.where("contract IS NOT NULL").order('surname ASC') 
  end 

  def duchod
    @users = User.where("retire IS NOT NULL").order('surname ASC') 
  end

   def ridic
    @users = User.where("rider IS NOT NULL").order('surname ASC') 
    @users2 = User.where("rider IS NULL").order('surname ASC') 
  end

  def self.birthdays
   # ruby script/rails runner 'UsersController.birthdays'

   if (Time.now+9.day).year - (Time.now+3.day).year > 0
      @users1=User.find_by_sql(["SELECT * FROM users WHERE (EXTRACT(DOY FROM birthday) >= EXTRACT(DOY FROM DATE(?))) OR (EXTRACT(DOY FROM birthday) <= EXTRACT(DOY FROM DATE(?))) ORDER BY EXTRACT(DOY FROM birthday)",Time.now+3.day,Time.now+9.day])
    else
      @users1=User.find_by_sql(["SELECT * FROM users WHERE (EXTRACT(DOY FROM birthday) >= EXTRACT(DOY FROM DATE(?))) AND (EXTRACT(DOY FROM birthday) <= EXTRACT(DOY FROM DATE(?))) ORDER BY EXTRACT(DOY FROM birthday)",Time.now+3.day,Time.now+9.day])
    end

    if (Time.now+3.day+1.month).year - (Time.now+10.day).year > 0
      @users2=User.find_by_sql(["SELECT * FROM users WHERE (EXTRACT(DOY FROM birthday) >= EXTRACT(DOY FROM DATE(?))) OR (EXTRACT(DOY FROM birthday) <= EXTRACT(DOY FROM DATE(?))) ORDER BY EXTRACT(DOY FROM birthday)",Time.now+10.day,Time.now+3.day+1.month])
    else
      @users2=User.find_by_sql(["SELECT * FROM users WHERE (EXTRACT(DOY FROM birthday) >= EXTRACT(DOY FROM DATE(?))) AND (EXTRACT(DOY FROM birthday) <= EXTRACT(DOY FROM DATE(?))) ORDER BY EXTRACT(DOY FROM birthday)",Time.now+10.day,Time.now+3.day+1.month])
    end
    if !@users1.empty? || !@users2.empty? 
      UserMailer.birthday(@users1,@users2).deliver  
    end
  end 
end
