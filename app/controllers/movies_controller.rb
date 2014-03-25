class MoviesController < ApplicationController

  ## initializing the ratings variable by refering to the Movie model
  def initialize
    super
    @all_ratings= Movie.all_ratings
  end


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # to keep track if page needs to be redirected based on changes
    redirect = false
    
    # retrieving the sorting parameter
    if params[:sort]
      @sort= params[:sort]
    elsif session[:sort]
      @sort= session[:sort]
      redirect=true
    end

    # retrieving the ratings parameter
    if params[:ratings]
      @ratings= params[:ratings]
    elsif session[:ratings]
      @ratings= session[:ratings]
      redirect=true
    else
      @all_ratings.each do |rates|
        (@ratings ||= { })[rates]=1
      end
      redirect=true
    end


    if redirect
      redirect_to movies_path(:sort=>@sort, :ratings=>@ratings)
    end

    # @movies = Movie.order(params[:sort], params[:ratings])

    ## getting all the movies and sorting parameters
    allMovies=Movie.find(:all, :order=>@sort ? @sort : :id)
    ## check for ratings selections, and add the parameter
    allMovies.each do |rateMovies|
      if @ratings.keys.include? rateMovies[:rating]
        (@movies ||= []) << rateMovies
      end
    end

     ## Storing session values for tags
     session[:sort]= @sort
     session[:ratings]= @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
