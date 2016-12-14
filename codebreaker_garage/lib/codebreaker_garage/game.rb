module Codebreaker_garage

  class Game

    ATTEMPTS = 9
    HINTS = 3

    attr_reader :attempts, :hints

    def initialize
      @generated_code = generate_code
      @attempts = ATTEMPTS
      @hints = HINTS
    end

    def has_attempts?
      @attempts != 0
    end

    def statistics
      {
        time: Time.now,
        secret_code: @generated_code.to_s,
        attempts: ATTEMPTS,
        hints: HINTS,
        user_attempts_left: @attempts,
        user_hints_left: @hints
      }
    end

    def receive_hint
      return "You have no hints." if @hints == 0
      @hints -= 1
      machine_codebreaker = (1..6).to_a
      hint = machine_codebreaker.repeated_permutation(4).to_a
      hint.select! {|code| code == @generated_code }
      hint.flatten![rand(4)]
    end


    def generate_code
      Array.new(4).map { rand(1..6) }
    end

    def guesser(guessed_code)
      @attempts -= 1
      result = ""
      associative_array = @generated_code.zip(guessed_code)
      associative_array.each do |array|
        if array[0] == array[1]
          result << "+"
          array[0] = array[1] = nil
        end
      end
      return result if result == "++++"

      associative_array.reject! {|element| element == [nil, nil]}
      transposed = associative_array.transpose

      transposed[0].each do |digit|
        next if !transposed[1].include?(digit)
        result << '-'
        transposed[1][transposed[1].find_index(digit)] = nil
      end
      result
    end

  end


end
