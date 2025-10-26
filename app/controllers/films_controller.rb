class FilmsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_public_film, only: %i[show]
  before_action :set_secure_film, only: %i[edit update destroy]

  # GET /films
  def index
    @scope = Film.order(created_at: :desc)

    @scope = @scope.where("title ILIKE ?", "%#{params[:search_title]}%") if params[:search_title].present?
    @scope = @scope.where("director ILIKE ?", "%#{params[:search_director]}%") if params[:search_director].present?
    @scope = @scope.where(release_year: params[:search_year].to_i) if params[:search_year].present?

    if params[:search_category].present?
      @scope = @scope.joins(:film_categories)
                     .where(film_categories: { category_id: params[:search_category].to_i })
    end

    if params[:search_tags].present?
      tag_names = params[:search_tags].split(",").map(&:strip).map(&:downcase)
      @scope = @scope.joins(:tags).where("LOWER(tags.name) IN (?)", tag_names).distinct
    end

    @films = @scope.page(params[:page]).per(6)
  end

  # GET /films/1
  def show
    @comments = @film.comments.order(created_at: :desc)
  end

  # GET /films/new
  def new
    @film = Film.new
  end

  # GET /films/1/edit
  def edit; end

  # POST /films
  def create
    @film = current_user.films.build(film_params)

    respond_to do |format|
      if @film.save
        format.html { redirect_to @film, notice: "Filme criado com sucesso." }
        format.json { render :show, status: :created, location: @film }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /films/1
  def update
    respond_to do |format|
      if @film.update(film_params)
        format.html { redirect_to @film, notice: "Filme atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @film }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1
  def destroy
    @film.destroy!
    respond_to do |format|
      format.html { redirect_to films_path, notice: "Filme apagado com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_public_film
    @film = Film.find(params[:id])
  end

  def set_secure_film
    @film = current_user.films.find(params[:id])
  end

  def film_params
    params.require(:film).permit(:title, :synopsis, :release_year, :duration, :director, :poster, :tag_list, category_ids: [])
  end
end
