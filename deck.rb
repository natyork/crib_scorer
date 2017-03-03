require_relative 'card'

# Deck creates a new suffled deck of hands and provides a method to deal
# out a given number of cards.
class Deck < Card
  def initialize
    @values = (1..13).to_a
    @suits = %w(clubs diamonds hearts spades)

    @deck = @values.flat_map do |value|
      @suits.map do |suit|
        Card.new(value, suit)
      end
    end

    @deck.shuffle!
  end

  def deal(number)
    @deck.shift(number)
  end
end
