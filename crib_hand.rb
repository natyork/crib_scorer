require 'pry'
require_relative 'deck'

# CribHand inherits from Deck, creates a crib hand and provides a method to
# score the crib hand.
class CribHand < Deck
  JACK = 11 # Might be something a Card should be responsible for
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

  # So i like the idea of a deck as a helper class, but when I see classes
  # that dont take initialization params, its a little bit of a red flag.
  #
  # Designing this class this way you have always locked a card hand into being
  # 5 random cards. You cant specify the particular hand you want
  def initialize
    @deck = Deck.new
    @starter = @deck.deal(1)
    @hand = @deck.deal(4)

    # Awesome attempt at the conditional assignment. But since this code will only ever
    # be run once per instance it doesnt really save you anything
    @full_hand ||= full_hand
    @hand_combinations ||= hand_combinations
  end

  def score
    fifteen_twos + flush + nob + pairs + runs
  end

  private

  def hand_combinations
    # I believe this is actually returning the combinations of point values
    # for cards... might not 100% be what you want
    # returns all possible card combinations for a given hand

    hand = @full_hand.map(&:points)

    combos = (MIN_COMBO_SIZE..MAX_COMBO_SIZE).flat_map do |size|
      hand.combination(size).to_a
    end

    # Why not store them in the loop above? I think it works out to the same
    # number of nested loops
    combos.map(&:sort)
  end

  def fifteen_twos
    # two points for each separate combination of two or more cards
    # totalling exactly fifteen
    # face cards count as 10

    # I like this
    POINTS[:fifteens] * @hand_combinations.count do |card_combo|
      card_combo.sum == SUM_EQ_FIFTEEN
    end
  end

  def flush
    # score 4 points when all 4 cards are of the same suit

    suits_in_hand = @hand.map(&:suit)

    # this could be what we call a guard clause to return early from
    # the method if there is no flush at all
    if suits_in_hand.all? { |card| card == suits_in_hand.first }
      flush_suit = suits_in_hand.first
      points = POINTS[:flush]
    end

    points += POINTS[:starter] if flush_suit == @starter.first.suit

    points || 0
  end

  # Hmm... you also have an instance variable above called full_hand.
  def full_hand
    # combines the starter card with the players hand

    @starter + @hand
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

    two_combos = @hand_combinations.select do |combo|
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

    # This might not work given that hand_combinations is all of the combinations
    # of point values instead of the card ranks
    run_list = @hand_combinations.select do |card_combo|
      run?(card_combo) && card_combo.length > MIN_COMBO_SIZE
    end

    max_run = max_run_length(run_list)

    number_of_runs = run_list.count { |run| run.length == max_run }
    max_run * number_of_runs
  end
end

crib_hand = CribHand.new
puts crib_hand.score
