class ScoresController < ApplicationController
  load_and_authorize_resource
  before_action :set_score, only: [:show, :edit, :update, :destroy]
  
  # GET /scores
  # GET /scores.json
  def index
    if current_user.user?
      @scores = current_user.scores 
    elsif current_user.teacher?
      @scores = Score.joins(:subject=>:department).where('departments.id = ?', current_user.department_id)
    else
      @scores = Score.all
    end
    @scores = @scores.batch_is(params[:batch]).semester_is(params[:semester])
    respond_to do |format|
      format.html
      format.pdf do
        result_summary = {pass: @scores.select{|x| x.mark.to_i > 30}, total: @scores}
        pdf = WickedPdf.new.pdf_from_string(ScoresController.new.render_to_string(:action => "/report", :page_height => '5in', :page_width => '7in', :layout => false, locals: {result_data: result_summary}))
        send_data(pdf, :filename => Time.now.to_i.to_s+".pdf", :disposition => 'attachment')
      end
    end
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
        raise CanCan::AccessDenied if ((@score.department.id != current_user.department_id) && !current_user.admin?)
  end

  # GET /scores/new
  def new
    @exams = Exam.all
    @subjects = Subject.all
    @subjects = @subjects.where(department_id: current_user.department_id) if !current_user.admin?
    @subjects = @subjects.map{|x| [x.name, x.id]}
    @exams = @exams.where(department_id: current_user.department_id) if !current_user.admin?
    @exams = @exams.map{|x| [x.name, x.id]}
    @users = User.user
    @users = @users.where(:department_id => current_user.department_id) if !current_user.admin?
    @users = @users.map{|x| ["#{x.name}-#{x.department.name}-#{x.year_of_adm}", x.id]}
    @score = Score.new
  end

  # GET /scores/1/edit
  def edit
    @exams = Exam.all
    @exams = @exams.map{|x| [x.name, x.id]}
    @users = User.user
    @users = @users.where(:department_id => current_user.department_id) if !current_user.admin?
    @users = @users.map{|x| ["#{x.name}-#{x.department.name}-#{x.year_of_adm}", x.id]}
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scores/1
  # PATCH/PUT /scores/1.json
  def update
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score, notice: 'Score was successfully updated.' }
        format.json { render :show, status: :ok, location: @score }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to scores_url, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params[:score][:date_of_exam] = params[:score][:date_of_exam].to_date
      params.require(:score).permit(:exam_id, :subject_id, :mark, :semester, :user_id, :date_of_exam)
    end
end
