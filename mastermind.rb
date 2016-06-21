class Game

  COLORS = ['r','o','y','g','b','p']

  def initialize
    @code = []
    @guess = []
    @guess_count = 0
  end

  def play
    start_game
    loop do
      if @guess_count > 11
        puts "Game over. You've exceeded your guess limit. The correct code was #{@code}."
        return
      else
        make_guess
        return if check_guess?
      end
    end
  end

  def make_guess
    loop do
      print "Enter your guess (or 'key' to refer to key): "
      guess = gets.gsub(/\s+/,'').downcase.split(//)
      p guess
      if valid_guess?(guess)
        @guess = guess
        @guess_count += 1
        return
      else
        puts "Invalid guess. Try again."
      end
    end
  end

  def valid_guess?(guess)
    guess.length == 4 && guess.all? { |letter| COLORS.include?(letter) } ? true : false
  end

  def check_guess?
    correct_spot, correct_color = 0, 0
    @guess.each_with_index { |color, i| correct_spot += 1 if color == @code[i] }
    @guess.each { |color| correct_color += 1 if @code.include?(color) }
    if correct_spot == 4
      puts "You win! It took you only #{@guess_count} guess(es)."
      return true
    else
      puts "You have #{correct_spot} of the correct color in the correct location "\
      "and #{correct_color - correct_spot} of the correct color in an incorrect location."
      return false
    end
  end

  def start_game
    puts "Welcome to Mastermind -- the code-breaking game!\n\n"
    #puts "Would you like to make or break the code?"
    puts "The computer will select a sequence of 4 colored pegs and your job will "\
    "be to break the code in 12 or fewer guesses. The computer will give you feedback "\
    "after each guess to help you break the code.\n\n"
    puts "Each peg can be any one of these 6 colors below. Remember that the code "\
    "can contain more than one peg of the same color. "
    print_key
    puts "At any point in the game, you can type 'key' to reference this key. \n\n"
    puts "Please enter your guesses as a string of 4 single letters representing "\
    "the 4 colored pegs in order. \n\n"
    4.times { @code.push(COLORS[rand(0..5)]) }
    p @code
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
