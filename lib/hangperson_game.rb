class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(char)
    raise ArgumentError.new("Empty Argument") if (char.nil? || char.empty?)
    
    str = char.to_str.downcase
    invalid = str =~ /[^a-zA-Z]/
    raise ArgumentError.new("Invalid Argument") unless invalid.nil?
    
    contains = @word =~ /#{str}/
    alreadyGuessed = @guesses =~ /#{str}/
    alreadyMisGuessed = @wrong_guesses =~ /#{str}/
    
    unless alreadyGuessed.nil? && alreadyMisGuessed.nil?
      return false  
    end
    
    unless contains.nil?
      @guesses << char
    else
      @wrong_guesses << char
    end
    return true
  end
  
  def word_with_guesses()
    guessesArray = @guesses.split(//)
    wordArray = @word.split(//)
    wordWithGuesses = @word.gsub(/./, '-')
      
    guessesArray.each{|c| wordArray.each_index {|i| 
        if wordArray[i].downcase == c
          wordWithGuesses[i] = wordArray[i]
        end
      }
    }
      return wordWithGuesses
  end
  
  def check_win_or_lose()
    return :lose if @wrong_guesses.size >= 7
    return :win if self.word_with_guesses == @word
    return :play
  end
  

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
