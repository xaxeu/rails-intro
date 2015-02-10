class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def movie_ratings
  Movie.select(:rating).uniq.map(&:rating)
#Movie.select('distinct rating').map(&:ratng)
  end
  
 
  
  def index
#  debugger
  @all_ratings = movie_ratings
  @selected_ratings = params[:ratings] || session[:ratings] || {}
  sort = params[:sort] || session[:sort]
  case sort
    when 'title'
      ordering = {:order => :title}
      @title_header = 'hilite'
    when 'release_date'
      ordering = {:order => :release_date}
      @date_header = 'hilite'
  end
  if @selected_ratings == {}
    @selected_ratings = Hash[@all_ratings.map {|rating| [rating,rating]}]
  end
 
  if session[:sort] != params[:sort] or session[:ratings] != params[:ratings]
    session[:sort] = sort
    session[:ratings] = @selected_ratings
    flash.keep
    return redirect_to :sort => sort, :ratings => @selected_ratings
  end
  @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)

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
