require 'pry'

# Since you dont call any rubo cop methods in this file you dont actually need
# to require it. You can just run it externally on this file without needing to
# require it
require 'rubocop'

# crib_hand.rb
class CribHand
  # hand given as an array, beginning with the starter card
  # each card is an array with index 0 being the value and
  # index 1 being the first letter of the suit
  # face cards input as numerical values J, Q, K are 11, 12, 13, respectively
  # example hand:
  # CribHand.new([[1, 's'], [3, 'h'], [13, 'h'], [2, 'd'], [5, 'c']])

  MAX_COMBO_SIZE = 5
  JACK = 11
  QUEEN = 12
  KING = 13

  def initialize(hand)
    @hand = hand

    # a slighly more 'clever' solution would be
    # @values, @suites = @hand.transpose
    # Since transpose return an array of the 2 values you want
    @values = @hand.transpose[0]
    @suits = @hand.transpose[1]

    # ruby has a method for this
    @starter_card = @hand[0]

    #ruby has a method for this
    @players_hand = @hand[1, 4]

    # I would consider splitting the player hand from the starter card
    # before separating values and suits.
    #
    # You could add a little more Stucture to the concept of a card by using a
    # Struct
    @players_hand_suits = @players_hand.transpose[1]
    @starter_suit = @suits[0]
  end

  def fifteen_twos
    # two points for each separate combination of two or more cards
    # totalling exactly fifteen
    # face cards count as 10

    points = 0 # does this need to be intialized here?
    min_combo_size = 2 # this is a varable the doesnt change.
    scoring_combination_total = 15 # this is a variable that doesnt chage
    face_card_value = 10 # same
    points_per_combo = 2 # same

    # It might be interesting to use a hash with a default value to implement this
    faces_to_tens = @values.map do |card|
      if [JACK, QUEEN, KING].include?(card)
        face_card_value
      else
        card
      end
    end

    hand_combinations = (min_combo_size..MAX_COMBO_SIZE).flat_map do |size|
      # pretty sure to_a here is redundant
      faces_to_tens.combination(size).to_a
    end

    points = points_per_combo * hand_combinations.count do |card_combo|
      card_combo.sum == scoring_combination_total
    end

    points
  end

  def runs
    # for runs of of 3 to 5 consecutive cards, the number of
    # points awarded is equal to the length of the run

    points = 0 # Does this need to be initialized
    min_combo_size = 3 # this is a variable that doesnt change
    max_run_length = 0 # Does this need to be initialized here?

    # This is the second time we are building the
    # (min_combo_size..MAX_COMBO_SIZE) construct might.
    hand_combinations = (min_combo_size..MAX_COMBO_SIZE).flat_map do |size|
      # again I believe #to_a is redundant here
      @values.combination(size).to_a.sort
    end

    # Nested loops should be avoided if at all possible. They super increase runtime.
    # In this case, since we are always guaranteed to have a 'constant' number
    # of hand combinations and that number is a relatively low number the impact
    # of the nested look is pretty small
    run_list = hand_combinations.select do |card_combo|
      # This is cool. I hadnt seen #each cons
      card_combo.each_cons(2).all? do |current_card, next_card|
        next_card == current_card + 1
      end
    end

    max_run_length = run_list.max_by(&:length).length if run_list.any?

    number_of_runs = run_list.count { |run| run.length == max_run_length }
    points = max_run_length * number_of_runs
  end

  def pairs
    # score 2 points for each unique pair combination

    points = 0 # does this need to be initialized here?
    combo_size = 2 # variable that doesnt change
    points_per_combo = 2 # variable that doesnt change

    # Second time we have run this operation on values
    hand_combinations = @values.combination(combo_size).to_a

    points = points_per_combo * hand_combinations.count do |card_combo|
      # There is a ruby method for getting the first element of an array
      card_combo.all? { |card| card == card_combo[0] }
    end

    points
  end

  def flush
    # score 4 points when all 4 cards are of the same suit

    points = 0 # Does this need to be initialized?
    points_per_flush = 4 # variable that doesnt change
    additional_point_for_starter = 1 # variable that doesnt change
    flush_suit = nil # Does this need to be initialized

    if @players_hand_suits.all? { |card| card == @players_hand_suits[1] }
      flush_suit = @players_hand_suits[1]
      points = points_per_flush
    end

    points += additional_point_for_starter if flush_suit == @starter_suit

    points
  end

  def nob
    # score 1 point if player is holding
    # the Jack with the same suit as the starter card

    points = 0 # Does this need to be initialized
    points_per_nob = 1 # Variable that doesnt change

    points = points_per_nob if @players_hand.include?([JACK, @starter_suit])

    points
  end

  # This is a good method :)
  # since this is all build into a class. Likely this method is the only method
  # which should be publicly available.
  def total_points
    fifteen_twos + pairs + runs + flush + nob
  end
end
