class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.xml
  def index
    @problem_set = ProblemSet.find(params[:problem_set_id])
    if session[:user_id].nil?
      session[:redirect_url] = problem_set_questions_path(@problem_set)
      redirect_to(@problem_set)
    else
    @questions = Question.where(:problem_set_id => params[:problem_set_id]).all
    @taken = Response.where(:problem_set_id => @problem_set.id, :user_id => session[:user_id]).size == @questions.size
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
      @problem_set = ProblemSet.find(params[:problem_set_id])
      if session[:user_id].nil?
        session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/"
        redirect_to("/login/")
      else
      @question = Question.where(:problem_set_id => params[:problem_set_id], :count => params[:id]).first
      if @question.nil?
        flash[:notice] = "NO SUCH QUESTION!"
        redirect_to :action=>"index"
      else
        @answer = Answer.where(:question_id => @question.id).all
        @response = Response.where(:user_id => session[:user_id], :question_id => @question.id).first
        if @response.nil?
          @response = Response.new
        end
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @question }
        end
      end
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new
    @problem_set = ProblemSet.find(params[:problem_set_id])
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index"
      else
        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @question }
        end
      end
    end
  end

  # GET /questions/1/edit
  def edit
    @problem_set = ProblemSet.find(params[:problem_set_id])
    if session[:user_id].nil?
      session[:redirect_url] = "/problem_sets/#{@problem_set.id}/questions/"
      redirect_to("/login/")
    else
      if session[:user_id].to_i != 126126126126126
        flash[:notice] = "NO PERMISSION!"
        redirect_to :action => "index" 
      else
        @question = Question.where(:count => params[:id], :problem_set_id => params[:problem_set_id]).first
        @answer = Answer.where(:question_id => @question.id).all
      end
   end
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question.problem_set_id = @problem_set.id
    @question.count = @problem_set.question_count + 1

    c = false
    ans = false

    @ans1 = Answer.new(params[:answer1]) 
    @ans2 = Answer.new(params[:answer2]) 
    @ans3 = Answer.new(params[:answer3]) 
    @ans4 = Answer.new(params[:answer4]) 

    if @ans1.correct or @ans2.correct or @ans3.correct or @ans4.correct
        c = true
    end
    if params[:answer1][:answer] == ""
        @ans1 = nil
    end
    if params[:answer2][:answer] == ""
        @ans2 = nil
    end
    if params[:answer3][:answer] == ""
        @ans3 = nil
    end
    if params[:answer4][:answer] == ""
        @ans4 = nil
    end

    if  @ans1 or @ans2 or @ans3 or @ans4
        ans = true    
    end

    respond_to do |format|
      if c and ans 
        if @question.save
          @problem_set.question_count += 1
          @problem_set.save          
          if @ans1
            @ans1.question_id = @question.id
            @ans1.save
          end
 
          if @ans2
            @ans2.question_id = @question.id
            @ans2.save
          end

          if @ans3
            @ans3.question_id = @question.id
            @ans3.save
          end
  
          if @ans4
            @ans4.question_id = @question.id
            @ans4.save
          end

          format.html { redirect_to(problem_set_questions_path(@problem_set), :notice => 'Question was successfully created.') }
          format.xml  { render :xml => @question, :status => :created, :location => @question }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
        end
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @ans1, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:id => params[:id], :problem_set_id => params[:problem_set_id]).first
    @answers = Answer.where(:question_id => @question.id)

    ans = [:answer1, :answer2, :answer3, :answer4]
    respond_to do |format|
      if @question.update_attributes(params[:question])
        
        @answers.each_with_index do |a, i|
          a.answer = params[ans[i]][:answer]
          a.correct = params[ans[i]][:correct]
          a.save
        end

        if @answers.size < 4 and params[ans[@answers.size]][:answer] != ""
          for i in @answers.size..4
            if params[ans[i]][:answer] != ""
              a = Answer.new(params[ans[i-1]])
              a.question_id = @question.id
              a.save
            end
          end
        end
        format.html { redirect_to(edit_problem_set_question_path(@problem_set.id, @question.count), :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  #TODO: need to reduce count for problem_set and perhaps reassign the numbers when a question gets removed from the problem set
  def destroy
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:id => params[:id], :problem_set_id => params[:problem_set_id]).first
    @answer = Answer.where(:question_id => params[:id]).all
    @answer.each do |a|
      a.destroy
    end
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(problem_set_questions_url) }
      format.xml  { head :ok }
    end
  end

end
