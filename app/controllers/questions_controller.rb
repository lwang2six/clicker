class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.where(:problem_set_id => params[:problem_set_id]).all
    @problem_set = ProblemSet.find(params[:problem_set_id])
    #puts problem_set_url
    puts "weee"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.where(:problem_set_id => params[:problem_set_id], :count => params[:id]).first
    @problem_set = ProblemSet.find(params[:problem_set_id])
    puts @problem_set.methods
    @answer = Answer.where(:question_id => @question.id).all
    @response = Response.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new
    @problem_set = ProblemSet.find(params[:problem_set_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:count => params[:id], :problem_set_id => params[:problem_set_id]).first
    @answer = Answer.where(:question_id => params[:id]).all
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
    @answer = Answer.where(:question_id => params[:id]).first

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @problem_set = ProblemSet.find(params[:problem_set_id])
    @question = Question.where(:id => params[:id], :problem_set_id => params[:problem_set_id]).first
    #@question = Question.find(params[:id])
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
