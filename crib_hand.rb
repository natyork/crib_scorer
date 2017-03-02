require File.expand_path('../crib_helper.rb', __FILE__)

class CribHand < CribHelper

  attr_reader :hand
  attr_reader :points

  #hand given as an array, beginning with the starter card
  #each card is an array with index 0 being the value and index 1 being the first letter of the suit
  #face cards input as numerical values J, Q, K are 11, 12, 13, respectively
  #example hand = CribHand.new([[1, 's'], [3, 'h'], [13, 'h'], [2, 'd'], [5, 'c']])
  def initialize(hand)
    @hand = hand
    @values = @hand.map { |card| card[0] }
    @suits = @hand.map { |card| card[1] }
    @starter = @hand[0]
    @points = 0
  end

  def score
    fifteen_twos
    runs
    pairs
    flush
    nob
  end

  private

  #each_with object
  def fifteen_twos
    new_values = face_to_tens(@values)
    combine(new_values).each do |subset|
      reduced_subset = subset.reduce(:+)
      if reduced_subset == 15
        @points +=2
      end
    end
  end

  def runs
    run_list = []
    (3..5).reverse_each do |size|
     @values.combination(size).to_a.each do |subset|
        sorted = subset.sort
        run_list << sorted if run?(sorted)
      end
      break if run_list.length > 0
    end

    run_list.each {|run| @points += run.length}
  end


  def pairs
    pair_list = []
    (2..4).reverse_each do |size|
     @values.combination(size).to_a.each do |subset|
        pair_list << subset if eq_arr_values?(subset)
      end
      break if pair_list.length > 0
    end

    pair_list.each do |set|
      case set.length
      when 2
        @points += 2
      when 3
        @points += 6
      when 4
        @points += 12
      end
    end
  end


  def flush
    @points += 4 if eq_arr_values?(@suits)
  end

  def nob
    starter_suit = @suits[0]
    remainder = @hand[1, 4]
    remainder.each do |card|
      @points +=1 if card[0] == 11 && card[1] == starter_suit
    end
  end
end

#tests
hand = CribHand.new([[5, 'h'], [5, 's'], [5, 'c'], [5, 'd'], [11, 'h']])
print hand.hand
puts ' score should be 29'
hand.score
puts hand.points == 29

hand = CribHand.new([[13, 'h'], [2, 's'], [4, 's'], [5, 'd'], [12, 's']])
print hand.hand
puts ' score should be 4'
hand.score
puts hand.points == 4

hand = CribHand.new([[2, 'h'], [2, 's'], [2, 'c'], [3, 'd'], [4, 's']])
print hand.hand
puts ' score should be 15'
hand.score
puts hand.points == 15

hand = CribHand.new([[2, 'h'], [3, 's'], [3, 'c'], [4, 'd'], [4, 's']])
print hand.hand
puts ' score should be 16'
hand.score
puts hand.points == 16

hand = CribHand.new([[4, 'h'], [4, 's'], [5, 'c'], [5, 'd'], [6, 's']])
print hand.hand
puts ' score should be 24'
hand.score
puts hand.points == 24
