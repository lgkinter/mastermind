class Game

  COLORS = ['r','o','y','g','b','p']

  def initialize
    @code = []
    @guess = []
    @code_breaker = true
    @guess_count = 0
  end

  def play
    start_game
    make_code
    loop do
      puts "@guess_count is #{@guess_count}"
      if @guess_count > 11 && @code_breaker
        puts "Game over. You've exceeded your guess limit. The correct code was #{@code}."
        return
      elsif @guess_count > 11 && !@code_breaker
        puts "Game over. The computer didn't guess your code within 12 guesses. You win!"
        return
      else
        make_guess
        if check_guess? && @code_breaker
          puts "You win! It took you only #{@guess_count} guess(es)."
          return
        elsif check_guess? && !@code_breaker
          puts "Game over. The computer won. It took the computer #{@guess_count} "\
          "tries to guess your secret code."
          return
        else
          puts "There are #{@correct_spot} of the correct color in the correct location "\
          "and #{@correct_color} of the correct color in an incorrect location."
        end
      end
    end
  end

  def make_guess
    if !@code_breaker && @guess.empty?
      4.times { @guess.push(COLORS[rand(0..5)]) }
      @guess_count = 1
      puts "The computer's guess is #{@guess}"
    elsif !@code_breaker
      guess = [1, 1, 1, 1]
      @guess.each_with_index { |color,i| guess[i] = color if color == @code[i] }
      @guess.each_with_index do |color, i|
          if color != @code[i] && (@code.count(color) - guess.count(color) > 0)
            guess.each_with_index do |letter, index|
              if guess[index] == 1 && @guess[index] != color
                guess[index] = color
                break
              end
            end
          end
        end
      guess.each_with_index {|color, i| guess[i] = COLORS[rand(0..5)] if color == 1}
      @guess = guess
      @guess_count += 1
      puts "The computer's guess is #{@guess}"
    else
      loop do
        print "Enter your guess (or 'key' to refer to key): "
        guess = gets.gsub(/\s+/,'').downcase.split(//)
        if valid_code?(guess)
          @guess = guess
          @guess_count += 1
          return
        else
          puts "Invalid guess. Try again."
        end
      end
      puts "Your guess is " + @guess
    end
  end

  def make_code
    if @code_breaker
      4.times { @code.push(COLORS[rand(0..5)]) }
      p @code
    else
      loop do
        print "Enter your secret code here (or 'key' to refer to key): "
        code = gets.gsub(/\s+/,'').downcase.split(//)
        if valid_code?(code)
          @code = code
          return
        else
          puts "Invalid code. Try again."
        end
      end
    end
  end

  def valid_code?(code)
    code.length == 4 && code.all? { |letter| COLORS.include?(letter) } ? true : false
  end

  def check_guess?
    @correct_spot, @correct_color = 0, 0
    matches = {'r' => 0, 'o' => 0, 'y' => 0, 'g' => 0, 'b' => 0, 'p' => 0}
    @guess.each_with_index do |color, i|
      if color == @code[i]
        matches[color] += 1
        @correct_spot += 1
      end
    end
    @guess.uniq.each { |color| @correct_color += [[0, (@guess.count(color) - matches[color])].max, (@code.count(color) - matches[color])].min }
    (@correct_spot == 4) ? (return true) : (return false)
  end

  def start_game
    puts "Welcome to Mastermind -- the code-breaking game!\n\n"
    loop do
      print "Would you like to make or break the code? Type 'make' or 'break'.  "
      user_input = gets.chomp.downcase
      if user_input == "make"
        @code_breaker = false
        break
      elsif user_input == "break"
        @code_breaker = true
        break
      else
        puts "Invalid entry. Try again."
      end
    end
    print "The computer will select a sequence of 4 colored pegs and your " if @code_breaker
    print "You will select a sequence of 4 colored pegs and the computer's " if !@code_breaker
    puts "job will be to break the code in 12 or fewer guesses."
    puts "After each guess, the computer will provide feedback to help crack the code.\n\n"
    puts "Each peg can be any one of these 6 colors below. Remember that the code "\
    "can contain more than one peg of the same color. "
    print_key
    puts "At any point in the game, you can type 'key' to reference this key. \n\n"
    print @code_breaker ?  "Please enter your guesses " : "Please enter your secret code "
    puts "as a string of 4 single letters representing the 4 colored pegs in order. \n\n"
  end

  def print_key
    puts "Key:"
    puts "   R = red"
    puts "   O = orange"
    puts "   Y = yellow"
    puts "   G = green"
    puts "   B = blue"
    puts "   P = purple"
  end

end

Game.new.play
