class CribHand
  attr_accessor :hand

  #hand given as an array, beginning with the starter card
  #each card is an array with index 0 being the value and index 1 being the first letter of the suit
  #face cards input as numerical values J, Q, K are 11, 12, 13, respectively
  #example hand = CribHand.new([[1, 's'], [3, 'h'], [13, 'h'], [2, 'd'], [5, 'c']])
  def initialize(hand)
    @hand = hand
    @values = @hand.map { |card| card[0] }
    @suits = @hand.map { |card| card[1] }
    @starter = @hand[0]
  end

#look up map and flatmap
  def combine(arr)
    combined_hand = []

    (2..5).each do |size|
      subset = arr.combination(size).to_a
      combined_hand << subset
    end

    combined_hand.flatten!(1)
  end

  def face_to_tens(arr)
    arr.map do |value|
      if [11, 12, 13].include?(value)
        value = 10
      else
        value
      end
    end
  end

#each_with object
  def fifteen_twos
    points = 0
    new_values = face_to_tens(@values)
    combine(new_values).each do |subset|
      reduced_subset = subset.reduce(:+)
      if reduced_subset == 15
        points +=2
      end
    end
    points
  end

  def runs
    points = 0
    run_list = []
    (3..5).reverse_each do |size|
     @values.combination(size).to_a.each do |subset|
        sorted = subset.sort
        run_list << sorted if run?(sorted)
      end
      break if run_list.length > 0
    end

    run_list.each {|run| points += run.length}
    points
  end

  def run?(arr)
    prev_num = arr[0]
    arr[1, arr.length].each do |current_num|
      return false if prev_num + 1 != current_num
      prev_num = current_num
    end
    return true
  end

  def pairs
    points = 0
    pair_list = []
    (2..4).reverse_each do |size|
     @values.combination(size).to_a.each do |subset|
        pair_list << subset if pair?(subset)
      end
      break if pair_list.length > 0
    end

    pair_list.each do |set|
      case set.length
      when 2
        points += 2
      when 3
        points += 6
      when 4
        points += 12
      end
    end

    points
  end

  def pair?(arr)
    prev_num = arr[0]
    arr[1, arr.length].each do |current_num|
      return false if prev_num != current_num
      prev_num = current_num
    end
    return true
  end

  def flush
    points = 0
    points += 4 if flush?(@suits)
    points
  end

  def flush?(arr)
    prev_num = arr[0]
    arr[1, arr.length].each do |current_num|
      return false if prev_num != current_num
      prev_num = current_num
    end
    return true
  end

  def nob
    points = 0
    starter_suit = @suits[0]
    remainder = @hand[1, 4]
    remainder.each do |card|
      points +=1 if card[0] == 11 && card[1] == starter_suit
    end
    points
  end

  def points
    puts 'fifteen_twos ' + fifteen_twos.to_s
    puts 'runs ' + runs.to_s
    puts 'pairs ' + pairs.to_s
    puts 'flush ' + flush.to_s
    puts 'nob ' + nob.to_s
    points = fifteen_twos + runs + pairs + flush + nob
    puts 'total points ' + points.to_s
    points
  end

end

#tests
hand = CribHand.new([[5, 'h'], [5, 's'], [5, 'c'], [5, 'd'], [11, 'h']])
print hand.hand
puts ' score should be 29'
puts hand.points == 29

hand = CribHand.new([[13, 'h'], [2, 's'], [4, 's'], [5, 'd'], [12, 's']])
print hand.hand
puts ' score should be 4'
puts hand.points == 4

hand = CribHand.new([[2, 'h'], [2, 's'], [2, 'c'], [3, 'd'], [4, 's']])
print hand.hand
puts ' score should be 15'
puts hand.points == 15

hand = CribHand.new([[2, 'h'], [3, 's'], [3, 'c'], [4, 'd'], [4, 's']])
print hand.hand
puts ' score should be 16'
puts hand.points == 16

hand = CribHand.new([[4, 'h'], [4, 's'], [5, 'c'], [5, 'd'], [6, 's']])
print hand.hand
puts ' score should be 24'
puts hand.points == 24
