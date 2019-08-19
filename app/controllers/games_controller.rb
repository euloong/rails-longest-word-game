# frozen_string_literal: true

# Class for the controller for the game
class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @grid = ('A'..'Z').to_a.sample(10).join
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    message(@word, @grid)
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(word, grid)
    word.chars.to_set.subset?(grid.chars.to_set)
  end

  def message(word, grid)
    @message = "Sorry but #{word} can't be built out of #{grid}"
    return unless included?(word.upcase, grid)

    @message = "Sorry but #{word} does not seem to be a valid english word."
    return unless english_word?(word)

    @message = "Congratulations! #{word} is a valid english word!"
  end
end
