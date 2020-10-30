#screen_example
#  ____________________________________
#
#    HANGMAN
#
#    l e _ _ e _ s  g o  h e _ e
#
#    TURNS: 12 
#
#  ____________________________________
#

class Screen


  def initialize letters, turns
    self.display_screen letters, turns
  end

  def display_screen letters, turns, guesses = nil
    guesses_str = ""
    guesses.each {|g| guesses_str += "#{g.upcase} "} if guesses
    
    display_str = "      ______________________________________________________\n
        HANGMAN\n \n 
        #{letters.join(" ")}\n \n
        TURNS: #{turns}\n
        GUESSED LETTERS: #{guesses_str}\n
      ______________________________________________________  
    "
    puts display_str
  end

end

class Dictionary

  attr_reader :word_set, :word_length, :word

  def initialize word_set, word_length
    @word_set = word_set
    @word_length = word_length
    @word = self.generate_word
  end

  def generate_word
    filtered_set = self.word_set.filter {|w| w.length >= self.word_length }
    filtered_set.sample
  end
end

class Game

  attr_accessor :board, :turns, :guesses, :winner
  attr_reader :secret_word

  def initialize secret_word, turns
    @secret_word = secret_word.downcase
    @board = self.build_board
    @turns = turns
    @guesses = []
    @winner = false
  end

  def build_board
    word_array = []
    self.secret_word.length.times {word_array << "_"}
    word_array
  end

  def compare_guess guess, guess_feedback
    
    word = self.secret_word.split""
    g = guess[0].downcase
    self.guesses << g

    p self.secret_word
  
    word.each_with_index do |letter, index| 
      if letter == g
        guess_feedback.slice!(index) 
        guess_feedback.insert(index, g)
      end 
    end

    self.winner = true if word == guess_feedback
  end

  def play_turn screen
    self.turns -= 1

    puts "\nEnter your guess...\n "
    guess = gets

    self.compare_guess guess, self.board
    screen.display_screen self.board, self.turns, self.guesses
  end

  def run_game screen
    until winner || self.turns == 0
      self.play_turn screen
    end
    puts winner ? "You win!\n " : "Game over!\n "
  end

end

words = File.open("dictionary.txt", "r").readlines(chomp: true)
dictionary = Dictionary.new words, 5
game = Game.new dictionary.word, 20
screen = Screen.new game.board, game.turns
game.run_game screen