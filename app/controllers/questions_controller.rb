class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  # GET /questions
  # GET /questions.json


  def index
    set_subgenre
    @questions = @subgenre.questions.all
  end

  def all
    @questions = Question.all
  end

  def check
    set_subgenre
    q =  Question.find_by(id: params[:qid])

    if params[:opa]==nil && params[:opb]==nil && params[:opc]==nil && params[:opd]==nil
      puts('Yeayy lifeline is being used')
      tmp = Lifeline.find_by(user_id: current_user.id, question_id: q.id)
      if tmp == nil
        tmp = Lifeline.create(user_id: current_user.id, question_id: q.id, used: true)
      end
      tmp.used = true
      tmp.save
      puts('Lifeline Used')
      redirect_to :action => 'index'

    else
      puts('Entered')
      puts('Entered')
      puts('Entered')
      puts('Entered')

    @choices = q.choices.all
    flag = 1
    if params[:opa] != nil
      if !@choices[0].correct
        puts('flag is set to 0 in A')
        flag = 0
      end
    end

    if params[:opb] != nil
      if !@choices[1].correct
        puts('flag is set to 0 in B')
        flag = 0
      end
    end

    if params[:opc] != nil
      if !@choices[2].correct
        puts('flag is set to 0 in C')
        flag = 0
      end
    end

    if params[:opd] != nil
      if !@choices[3].correct
        flag = 0
        puts('flag is set to 0 in D')
      end
    end

    puts(flag)

    Status.create(user_id: current_user.id, subgenre_id: @subgenre.id, question_id: params[:qid])

    temp = Leaderboard.find_by(user_id: current_user.id, subgenre_id: @subgenre.id)
    if temp == nil
      temp = Leaderboard.create(user_id: current_user.id, subgenre_id: @subgenre.id, score: 0, genre_id: @subgenre.genre_id)
    end
      if flag == 1
        frus = Lifeline.find_by(user_id: current_user.id, question_id: q.id)
      if frus == nil || frus.used == false
        scre = temp.score + 10
        temp.update(score: scre)

      else
        scre = temp.score+5
        temp.update(score: scre)
        puts('Yeay! score increased')
        temp.save
      end
    end
    temp.save
    redirect_to :action => 'index'
    end
  end
  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  def new_question
    @question = Question.new
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    if current_user.admin
    set_subgenre
    @question = Question.new(question_params)
    @question.subgenre_id = @subgenre.id
    @question.save

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
end
  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    if current_user.admin
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
end
  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    if current_user.admin
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end
    def set_subgenre
      @subgenre = Subgenre.find(params[:subgenre_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:question_desc, :is_multiple)
    end
end
