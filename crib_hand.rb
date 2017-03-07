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
    starter: 1,
    nob: 1
  }.freeze
  SUM_EQ_FIFTEEN = 15

  def initialize(starter, hand)
   # @deck = Deck.new
    @starter = starter
    @hand = hand
    @full_hand = @starter + @hand
    @full_hand_values = @full_hand.map(&:value)
  end

  def score
    fifteen_twos + flush + nob + pairs + runs
  end

  private

  def hand_combinations(hand)
    # returns all possible card combinations for a given hand

    combos = (MIN_COMBO_SIZE..MAX_COMBO_SIZE).flat_map do |size|
      hand.combination(size).to_a
    end

    combos.map(&:sort)
  end

  def fifteen_twos
    # two points for each separate combination of two or more cards
    # totalling exactly fifteen
    # face cards count as 10

    hand = @full_hand.map(&:points)

    POINTS[:fifteens] * hand_combinations(hand).count do |card_combo|
      card_combo.sum == SUM_EQ_FIFTEEN
    end
  end

  def flush
    # score 4 points when all 4 cards are of the same suit

    suits_in_hand = @hand.map(&:suit)

    if suits_in_hand.all? { |card| card == suits_in_hand.first }
      flush_suit = suits_in_hand.first
      points = POINTS[:flush]
    end

    points += POINTS[:starter] if flush_suit == @starter.first.suit

    points || 0
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

    POINTS[:nob] * @hand.count do |card|
      card.value == JACK && card.suit == @starter.first.suit
    end
  end

  def pairs
    # score 2 points for each unique pair combination

    two_combos = hand_combinations(@full_hand_values).select do |combo|
      combo.length == MIN_COMBO_SIZE
    end

    POINTS[:pairs] * two_combos.count do |card_combo|
      card_combo.all? { |card| card == card_combo.first }
    end
  end

  def run?(card_combo)
    # determines if a given card combo is a run and returns a boolean

    card_combo.each_cons(2).all? do |current_card, next_card|
      next_card == current_card + 1
    end
  end

  def runs
    # for runs of of 3 to 5 consecutive cards, the number of
    # points awarded is equal to the length of the run

    run_list = hand_combinations(@full_hand_values).select do |card_combo|
      run?(card_combo) && card_combo.length > MIN_COMBO_SIZE
    end

    max_run = max_run_length(run_list)

    number_of_runs = run_list.count { |run| run.length == max_run }
    max_run * number_of_runs
  end
end
