class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /genres
  # GET /genres.json
  def index
    @genres = Genre.all
  end

  # GET /genres/1
  # GET /genres/1.json
  def show
  end

  # GET /genres/new
  def new
      @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  # POST /genres
  # POST /genres.json
  def create
    if current_user.admin
    @genre = Genre.new(genre_params)

    respond_to do |format|
      if @genre.save
        format.html { redirect_to @genre, notice: 'Genre was successfully created.' }
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end
end
  # PATCH/PUT /genres/1
  # PATCH/PUT /genres/1.json
  def update
    if current_user.admin
    respond_to do |format|
      if @genre.update(genre_params)
        format.html { redirect_to @genre, notice: 'Genre was successfully updated.' }
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :edit }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end
end
  # DELETE /genres/1
  # DELETE /genres/1.json
  def destroy
    if current_user.admin
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_url, notice: 'Genre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def genre_params
      params.require(:genre).permit(:name, :description)
    end
end
