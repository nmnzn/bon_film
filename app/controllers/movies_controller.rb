class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
    @long_description = @movie.wikipedia_extract(locale: "fr") || @movie.overview
  end
end
