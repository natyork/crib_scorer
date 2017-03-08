require 'pry'
require_relative 'deck'

# CribHand inherits from Deck, creates a crib hand and provides a method to
# score the crib hand.
class CribHand < Deck
  MIN_COMBO_SIZE = 2
  MAX_COMBO_SIZE = 5
  MIN_COMBO_RUNS = 3
  POINTS = {
    fifteens: 2,
    pairs: 2,
    flush: 4,
    starter: 5,
    nob: 1
  }.freeze
  SCORABLE_COMBINATION_SUM = 15

  def initialize(starter, hand)
    @starter = starter
    @hand = hand
    @full_hand = @starter + @hand
    @full_hand_values = @full_hand.map(&:value)
  end

  def score
    fifteen_twos + flush + nob + pairs + runs
  end

  private

  def hand_combinations
    # returns all possible card combinations for a given hand

    @hand_combinations ||= (MIN_COMBO_SIZE..MAX_COMBO_SIZE).flat_map do |size|
      @full_hand.combination(size).to_a
    end
  end

  def fifteen_twos
    # two points for each separate combination of two or more cards
    # totalling exactly fifteen
    # face cards count as 10

    n_scoring_combinations = hand_combinations.count do |card_combo|
      card_points = card_combo.map(&:points)
      card_points.sum == SCORABLE_COMBINATION_SUM
    end

    POINTS[:fifteens] * n_scoring_combinations
  end

  def flush
    # score 4 points when all 4 cards are of the same suit

    suits_in_hand = @hand.map(&:suit)
    flush_suit = suits_in_hand.first

    return 0 unless suits_in_hand.all? { |card| card == flush_suit }

    flush_suit == @starter.first.suit ? POINTS[:starter] : POINTS[:flush]
  end

  def max_run_length(run_list)
    # determines the maximum run length from a list of run combinations

    max_run = run_list.max_by(&:length)
    if max_run
      max_run.length
    else
      0
    end
  end

  def nob
    # score 1 point if player is holding
    # the Jack with the same suit as the starter card

    return 0 if @hand.none? do |card|
      card.jack? && card.suit == @starter.first.suit
    end

    POINTS[:nob]
  end

  def pairs
    # score 2 points for each unique pair combination

    two_combos = hand_combinations.select do |combo|
      combo.length == MIN_COMBO_SIZE &&
        combo.map(&:value).all? { |card| card == combo.first.value }
    end

    POINTS[:pairs] * two_combos.length
  end

  def run?(card_combo)
    # determines if a given card combo is a run and returns a boolean
    return if card_combo.length <= MIN_COMBO_SIZE

    card_values = card_combo.map(&:value).sort

    card_values.each_cons(2).all? do |current_card, next_card|
      next_card == current_card + 1
    end
  end

  def runs
    # for runs of of 3 to 5 consecutive cards, the number of
    # points awarded is equal to the length of the run

    run_list = hand_combinations.select do |card_combo|
      run?(card_combo)
    end

    max_run = max_run_length(run_list)

    number_of_runs = run_list.count { |run| run.length == max_run }
    max_run * number_of_runs
  end
end
