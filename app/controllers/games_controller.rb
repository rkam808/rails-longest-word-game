require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    if word?(params[:answer]) && in_grid?(params[:answer])
      @score = "Congratulations! #{params[:answer]} is a valid English word!"
    elsif word?(params[:answer]) == false
      @score = "Sorry but #{params[:answer]} does not seem to be a valid English word..."
    elsif in_grid?(params[:answer]) == false
      @score = "Sorry but #{params[:answer]} can't be built out of #{params[:letters]}"
    end
  end

  private

  def word?(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    serialized = URI.open(url).read
    JSON.parse(serialized)["found"]
  end

  def in_grid?(answer)
    @letters = params[:letters].split()
    answer_arr = answer.split(//)
    answer_arr.each do |letter|
      if @letters.include?(letter.upcase)
        @letters.delete_at(@letters.index(letter.upcase))
      else
        return false
      end
    end
    return true
  end
end
