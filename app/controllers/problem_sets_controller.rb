class ProblemSetsController < ApplicationController
  # GET /problem_sets
  # GET /problem_sets.xml
  def index
    @problem_sets = ProblemSet.all
    @problem_set = ProblemSet.new
    if session[:user_id].nil?
        session[:redirect_url] = problem_sets_url
        redirect_to :action => "login"
    else 
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @problem_sets }
      end
    end
  end

  # GET /problem_sets/1
  # GET /problem_sets/1.xml
  def show
    @problem_set = ProblemSet.find(params[:id])
    if session[:user_id].nil?
        session[:redirect_url] = problem_set_path(@problem_set)
        redirect_to :action => "login"
    else 
      @questions = Question.where(:problem_set_id => @problem_set.id)
      @question = Question.where(:problem_set_id => @problem_set.id).first

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @problem_set }
      end
    end
  end

  # GET /problem_sets/new
  # GET /problem_sets/new.xml
  def new
    @problem_set = ProblemSet.new
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/new/"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index"
      else
        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @problem_set }
        end
      end
    end
  end

  # GET /problem_sets/1/edit
  def edit
    @problem_set = ProblemSet.find(params[:id])
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/edit/"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index"
      end
    end
  end

  # POST /problem_sets
  # POST /problem_sets.xml
  def create
    @problem_set = ProblemSet.new(params[:problem_set])
    if params[:user_id]
      session[:user_id] = params[:user_id]
      if session[:redirect_url].nil?
        redirect_to :action => "index"
      else
        r_to = session[:redirect_url]
        session[:redirect_url] = nil
        redirect_to(r_to) 
      end
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

  #TODO: to be moved when a user model is implemented
  def login
    @problem_set = ProblemSet.new
    @question = Question.new
    @response = Response.new
    
    render :action => "login"
  end
  def logout
    session[:user_id] = nil
    redirect_to :action => "login"
  end

  def result
    @problem_set = ProblemSet.find(params[:id])
   if session[:user_id].nil?
       session[:redirect_url] = "/problem_sets/#{@problem_set.id}/result/"
        redirect_to :action => "login"
   else 

    questions   = Question.where(:problem_set_id => @problem_set.id).all
    @result = []
    questions.each_with_index do |q, i| 
      @result[i] = {}
      @result[i][:question] = q
      @result[i][:answers] = Answer.where(:question_id => q.id)
      total = {}
      res = Response.where(:question_id => q.id)
      @result[i][:answers].each_with_index do |a, j|
        total[j] = res.where(:answer_id => a.id).size
      end
      @result[i][:total] = total
      @result[i][:response] = Response.where(:user_id => session[:user_id], :question_id => q.id).first
    end

    #user_id hardcoded, TODO:// create user model 
    if @result[0][:response].nil? && session[:user_id] != '126126126126126'
      respond_to do |format|
         format.html { redirect_to(problem_set_questions_path(@problem_set.id), :notice => "Must take the quiz first to see the results!!!") }
      end
    else
      render :action => "result" 
    end
   end
  end










end
