# Try adding the rubocop gem to your local ruby and running it against
# your code.
require 'pry'

class CribHand
  #hand given as an array, beginning with the starter card
  #each card is an array with index 0 being the value and index 1 being the first letter of the suit
  #face cards input as numerical values J, Q, K are 10, 12, 13, respectively
  #example hand = CribHand.new([[1, 's'], [3, 'h'], [13, 'h'], [2, 'd'], [5, 'c']])

  def initialize(hand)
    @hand = hand


    # Given we know there are only two elements in each sub array, this could be
    # map(&:first)
    #
    # If you were feeling clever you might want to look into the #transpose
    # array method
    @values = @hand.map { |card| card[0] }

    # Similar to above
    @suits = @hand.map { |card| card[1] }
  end

  # Yowza this is a long method that is crazy to read because every thing is
  # performed in inline blocks. "better" doesnt always mean "fewer lines"
  def points
    points = 0

    # fifteen_twos
    # There are a lot of magic numbers here, magic numbers (strings) are values
    # just floating around in code with no context or semantic meaning. If I tell you
    # 55. It doesnt give you any information about what 55 means.
    #
    # Explore the idea of constants to remove magic nubers from your code
    faces_to_tens = @values.map { |card| [11, 12, 13].include?(card) ? 10 : card }

    # Doesn't combination already return an array?
    hand_combinations = (2..5).flat_map { |size| faces_to_tens.combination(size).to_a }

    # More magic numbers! more fun!
    points += 2 * hand_combinations.count { |card_combo| card_combo.sum == 15 }

    # runs
    hand_combinations = (3..5).flat_map { |size| @values.combination(size).to_a.sort }

    # 1 letter variable name.... letters are free, you can use as many as you need
    run_list = hand_combinations.select { |card_combo| card_combo.each_cons(2).all? {|a, b| b == a + 1 } }
    max_run_length = run_list.length > 0 ? run_list.max_by(&:length).length : 0

    points +=  max_run_length * run_list.count { |run| run.length == max_run_length }

    # pairs
    hand_combinations = @values.combination(2).to_a
    points += 2 * hand_combinations.count { |card_combo| card_combo.all? { |card| card == card_combo[0] } }

    # flush
    points += 4 if @suits[1, 4].all? { |card| card == @suits[1] }
    points += 1 if @suits.all? { |card| card == @suits[0] }

    # nob
    starter_suit = @suits[0]
    players_hand = @hand[1, 4]
    points += 1 if players_hand.include?([11, starter_suit])

    points
  end
end


# So general comments:
#
# This is super hard to read. I acually preferred when you had more methods
# because your code was more semantic and easier for someone who doesnt
# understand the rules of crib to know what you were doing and why you were doing it
#
# This 1 method approach is too messy and unmaintainable. It would take someone
# a few hours to properly read through and understand the current behaviour of this
# code, if they every came here to make changes in the future.
#
# Good code doesnt mean all on one line with short variable names. Its more about
# Abstracting complexe behaviour in small, understandable chunks.
#
# If I i write a method called: #compute_thermodynamic_constant, someone else
# might not need to know how I calculated the thing inside the method to use the
# method. Its semantic and it abstracts the complicated method internals into
# something digestable.
#
# I dont know what SecureRandom.hex does internally. But I do know that it will
# give me 16 random hex characters, and thats enough for me to use it in my code
