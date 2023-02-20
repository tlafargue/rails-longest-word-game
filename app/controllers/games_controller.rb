require 'rest-client'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def word_in_grid?(word, grid)
    word.split("").reduce do |sum, letter|
      sum && grid.delete_at(grid.index(letter.upcase) || grid.length)
    end
  end

  def word_is_english?(word)
    response = JSON.parse(RestClient.get("https://wagon-dictionary.herokuapp.com/#{word}"))
    response["found"]
  end

  def score
    if word_in_grid?(params[:word], params[:letters].split(" "))
      if word_is_english?(params[:word])
        @message = "Congratulations! #{params[:word]} is a valid English word!"
        if session[:score]
          session[:score] += params[:word].length ** 2
        else
          session[:score] = params[:word].length ** 2
        end
      else
        @message = "Sorry, #{params[:word]} is not a valid English word!"
      end
    else
      @message = "Hmm, #{params[:word]} can't be built using #{params[:letters]}"
    end
  end
end
