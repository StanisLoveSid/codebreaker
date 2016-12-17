module Codebreaker_garage

  class Console

    require 'yaml'

    def initialize
      @game = Game.new
      @user_tries_to_guess = ''
    end

    def save_data
      puts "Enter your name"
      data = @game.statistics
      data[:user_name] = gets.chomp
      File.write("./statistics.yaml", data.to_yaml)
      replay
    end

    def replay
      puts "Do you want to play again? [y/n]"
      exit if gets.chomp != 'y'
      @game = Game.new
      start
    end

    def want_to_save
      puts 'Do you want to save the game result? [y/n]'
      save_data if gets.chomp == 'y'
      replay
    end

    def correct_input
      user_guessing = []
      @user_tries_to_guess.each_char {|char| user_guessing.push char.to_i }
      result = @game.give_result(user_guessing)
      puts result
      want_to_save if result == "++++"
    end

    def start
      puts "New game has been started"
      while @game.has_attempts?
        case @user_tries_to_guess = gets.chomp
        when /^[1-6]{4}$/
          correct_input
        when 'hint'
          puts @game.receive_hint
        when 'exit'
          return
        else
          puts 'You can use only 4 numbers from 1 to 6.'
        end
      end
      want_to_save
    end

  end

end
