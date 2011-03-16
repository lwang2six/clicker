class ProblemSetsController < ApplicationController
  # GET /problem_sets
  # GET /problem_sets.xml
  def index
    @problem_sets = ProblemSet.all
    if not session[:user_id]
      @problem_set = ProblemSet.new
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @problem_sets }
    end
  end

  # GET /problem_sets/1
  # GET /problem_sets/1.xml
  def show
    @problem_set = ProblemSet.find(params[:id])
    @questions = Question.where(:problem_set_id => @problem_set.id)
    @question = Question.where(:problem_set_id => @problem_set.id).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @problem_set }
    end
  end

  # GET /problem_sets/new
  # GET /problem_sets/new.xml
  def new
    @problem_set = ProblemSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @problem_set }
    end
  end

  # GET /problem_sets/1/edit
  def edit
    @problem_set = ProblemSet.find(params[:id])
  end

  # POST /problem_sets
  # POST /problem_sets.xml
  def create
    @problem_set = ProblemSet.new(params[:problem_set])
    if params[:user_id]
      session[:user_id] = params[:user_id]
      redirect_to :action => :index
    else
      respond_to do |format|
        if @problem_set.save
          format.html { redirect_to(@problem_set, :notice => 'Problem set was successfully created.') }
          format.xml  { render :xml => @problem_set, :status => :created, :location => @problem_set }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @problem_set.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /problem_sets/1
  # PUT /problem_sets/1.xml
  def update
    @problem_set = ProblemSet.find(params[:id])

    respond_to do |format|
      if @problem_set.update_attributes(params[:problem_set])
        format.html { redirect_to(@problem_set, :notice => 'Problem set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @problem_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_sets/1
  # DELETE /problem_sets/1.xml
  def destroy
    @problem_set = ProblemSet.find(params[:id])
    @problem_set.destroy

    respond_to do |format|
      format.html { redirect_to(problem_sets_url) }
      format.xml  { head :ok }
    end
  end

  def result
    @problem_set = ProblemSet.find(params[:id])
    questions   = Question.where(:problem_set_id => @problem_set.id).all
    @result = []
    questions.each_with_index do |q, i| 
      @result[i] = {}
      @result[i][:question] = q
      @result[i][:answers] = Answer.where(:question_id => q.id)
      @result[i][:response] = Response.where(:user_id => session[:user_id], :question_id => q.id).first
    end

     render :action => "result" 

  end










end
