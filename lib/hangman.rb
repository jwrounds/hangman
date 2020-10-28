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

  def display_screen letters, turns
    display_str = "      ____________________________________\n
        HANGMAN\n \n 
        #{letters.join(" ")}\n \n
        TURNS: #{turns}\n
      ____________________________________ 
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

  attr_accessor :board, :turns
  attr_reader :secret_word

  def initialize secret_word, turns
    @secret_word = secret_word
    @board = self.build_board
    @turns = turns
  end

  def build_board
    word_array = []
    self.secret_word.length.times {word_array << "_"}
    word_array
  end

  def compare_guess guess
    word = self.secret_word.split ""
    g = guess.split ""

    guess_feedback = []
    word.each {|e| e == g ? guess_feedback << g : guess_feedback << "_" }
    guess_feedback  
  end

  def play_turn screen
    self.turn -= 1

    puts "\nEnter your guess..."
    guess = gets

    self.board = self.compare_guess guess
    screen.display_screen self.board, self.turn
  end

end

words = File.open("dictionary.txt", "r").readlines(chomp: true)
dictionary = Dictionary.new words, 5
game = Game.new dictionary.word, 12
screen = Screen.new game.board, game.turns