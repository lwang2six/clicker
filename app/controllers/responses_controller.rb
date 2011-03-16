class ResponsesController < ApplicationController
  # GET /responses
  # GET /responses.xml
  def index
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:problem_set_id => @problem_set.id, :count => params[:question_id].to_i).first
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/#{@question.count}/responses/"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to("/problem_sets/#{@problem_set.id}/questions/#{@question.count}/")
      else
        @responses = Response.where(:question_id => @question.id)

        respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @responses }
        end
      end
    end
  end

  # GET /responses/1
  # GET /responses/1.xml
  def show
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:problem_set_id => @problem_set.id, :count=> params[:question_id].to_i).first
    @response = Response.find(params[:id])
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/#{@question.count}/responses/#{@response.id}"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index" 
      else
        @answer = Answer.find(@response.answer_id)

        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @response }
        end
      end
    end
  end

  # GET /responses/new
  # GET /responses/new.xml
  def new
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:problem_set_id => params[:problem_set_id])[params[:question_id].to_i - 1]
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/#{@question.count}/responses/new/"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index" 
      else
        @response = Response.new
        @answer = Answer.where(:question_id => @question.id)
      
       respond_to do |format|
         format.html # new.html.erb
         format.xml  { render :xml => @response }
       end
     end
    end
  end

  # GET /responses/1/edit
  def edit
    @response = Response.find(params[:id])
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.find(params[:question_id])
    if session[:user_id].nil?
      session[:redirect_url] = edit_problem_set_question_response_path(@problem_set.id, @question.count, @response)
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index" 
      else
        @answer = Answer.where(:id => @response.answer_id).all
      end
    end
  end

  # POST /responses
  # POST /responses.xml
  def create
    if not session[:user_id]
      session[:user_id] = params[:user_id]
      redirect_to(problem_set_question_path(session[:prob_id], session[:ques_id])) 
    else
      @problem_set = ProblemSet.find(params[:problem_set_id])  
      @question = Question.find(params[:question_id])
      @answer = Answer.find(params[:response])
      @response = Response.new( :answer_id => @answer.id, :result => @answer.correct, :question_id => @question.id, :problem_set_id => @problem_set.id, :user_id => session[:user_id])    
    
      if @problem_set.question_count > @question.count
        next_question = Question.where(:problem_set_id => @problem_set.id, :count => @question.count + 1).first
        result = problem_set_question_path(@problem_set.id, next_question.count)
      else
        result = "/problem_sets/#{@problem_set.id}/result/"
      end
      respond_to do |format|
        if @response.save
          format.html { redirect_to(result, :notice => 'Response was successfully created.') }
          format.xml  { render :xml => @response, :status => :created, :location => @response }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @response.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /responses/1
  # PUT /responses/1.xml
  def update
    @response = Response.find(params[:id])
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.find(params[:question_id])

    respond_to do |format|
      if @response.update_attributes(params[:response])
        format.html { redirect_to(@response, :notice => 'Response was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @response.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.xml
  def destroy
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.find(params[:question_id])
    @response = Response.find(params[:id])
    @response.destroy

    respond_to do |format|
      format.html { redirect_to(problem_set_question_responses_url) }
      format.xml  { head :ok }
    end
  end
end
