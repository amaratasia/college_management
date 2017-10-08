class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:department).all
    @users = @users.where(:department_id=> current_user.department_id) if current_user.teacher?
    respond_to do |format|
      format.html
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(UsersController.new.render_to_string(:action => "/report", :page_height => '5in', :page_width => '7in', :layout => false, locals: {user_data: @users }))
        send_data(pdf, :filename => Time.now.to_i.to_s+".pdf", :disposition => 'attachment')
      end
    end
  end

  def show
    raise CanCan::AccessDenied if ((@user.department_id != current_user.department_id) && current_user.teacher?)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :reg_number, :phone, :year_of_adm, :department_id)
    end
end
