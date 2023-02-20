require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alpha = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alpha.sample
    end
  end

  def score
    @grid = params[:letters]
    @attempt = params[:result_input]
    @result = run_game(@attempt, @grid)
  end

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_word_str = URI.open(url).read
    attempt_word = JSON.parse(attempt_word_str)

    return attempt_word["found"]
  end

  def included?(attempt, grid)
    attempt.chars.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
  end

  def run_game(attempt, grid)
    result = {}
    if included?(attempt.upcase, grid) == false
      result[:score] = 0
      result[:message] = "not in the grid"
    elsif english?(attempt) == false
      result[:score] = 0
      result[:message] = "not an english word"
    else
      result[:score] = 1000 + (attempt.size)*10
      result[:message] = "Well Done!"
    end

    result
  end


  # def run_game(attempt, grid, start_time, end_time)
  #   result = { time: end_time - start_time }
  #   if english?(attempt) == false
  #     result[:score] = 0
  #     result[:message] = "not an english word"
  #   elsif included?(attempt.upcase, grid) == false
  #     result[:score] = 0
  #     result[:message] = "not in the grid"
  #   else
  #     result[:score] = 1000 + (attempt.size)*10 - (end_time - start_time)
  #     result[:message] = "Well Done!"
  #   end

  #   result
  # end

end
