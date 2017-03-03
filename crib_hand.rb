
require 'pry'
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
    @values = @hand.transpose[0]
    @suits = @hand.transpose[1]
    @starter_card = @hand[0]
    @players_hand = @hand[1, 4]
    @players_hand_suits = @players_hand.transpose[1]
    @starter_suit = @suits[0]
  end

  def fifteen_twos
    # two points for each separate combination of two or more cards
    # totalling exactly fifteen
    # face cards count as 10

    points = 0
    min_combo_size = 2
    scoring_combination_total = 15
    face_card_value = 10
    points_per_combo = 2

    faces_to_tens = @values.map do |card|
      if [JACK, QUEEN, KING].include?(card)
        face_card_value
      else
        card
      end
    end

    hand_combinations = (min_combo_size..MAX_COMBO_SIZE).flat_map do |size|
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

    points = 0
    min_combo_size = 3
    max_run_length = 0

    hand_combinations = (min_combo_size..MAX_COMBO_SIZE).flat_map do |size|
      @values.combination(size).to_a.sort
    end

    run_list = hand_combinations.select do |card_combo|
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

    points = 0
    combo_size = 2
    points_per_combo = 2

    hand_combinations = @values.combination(combo_size).to_a

    points = points_per_combo * hand_combinations.count do |card_combo|
      card_combo.all? { |card| card == card_combo[0] }
    end

    points
  end

  def flush
    # score 4 points when all 4 cards are of the same suit

    points = 0
    points_per_flush = 4
    additional_point_for_starter = 1
    flush_suit = nil

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

    points = 0
    points_per_nob = 1

    points = points_per_nob if @players_hand.include?([JACK, @starter_suit])

    points
  end

  def total_points
    fifteen_twos + pairs + runs + flush + nob
  end
end
