require 'pry'

class CribHand
  #hand given as an array, beginning with the starter card
  #each card is an array with index 0 being the value and index 1 being the first letter of the suit
  #face cards input as numerical values J, Q, K are 10, 12, 13, respectively
  #example hand = CribHand.new([[1, 's'], [3, 'h'], [13, 'h'], [2, 'd'], [5, 'c']])
  def initialize(hand)
    @hand = hand
    @values = @hand.map { |card| card[0] }
    @suits = @hand.map { |card| card[1] }
  end

  def points
    points = 0

    # fifteen_twos
    faces_to_tens = @values.map { |card| [11, 12, 13].include?(card) ? 10 : card }
    hand_combinations = (2..5).flat_map { |size| faces_to_tens.combination(size).to_a }
    points += 2 * hand_combinations.count { |card_combo| card_combo.sum == 15 }

    # runs
    hand_combinations = (3..5).flat_map { |size| @values.combination(size).to_a.sort }
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
