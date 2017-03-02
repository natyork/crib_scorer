require File.expand_path('../crib_hand.rb', __FILE__)

#tests
hand = CribHand.new([[5, 'h'], [5, 's'], [5, 'c'], [5, 'd'], [11, 'h']])
print hand.hand
puts ' score should be 29'
puts hand.points

hand = CribHand.new([[13, 'h'], [2, 's'], [4, 's'], [5, 'd'], [12, 's']])
print hand.hand
puts ' score should be 4'
hand.score
puts hand.points

hand = CribHand.new([[2, 'h'], [2, 's'], [2, 'c'], [3, 'd'], [4, 's']])
print hand.hand
puts ' score should be 15'
hand.score
puts hand.points

hand = CribHand.new([[2, 'h'], [3, 's'], [3, 'c'], [4, 'd'], [4, 's']])
print hand.hand
puts ' score should be 16'
hand.score
puts hand.points

hand = CribHand.new([[4, 'h'], [4, 's'], [5, 'c'], [5, 'd'], [6, 's']])
print hand.hand
puts ' score should be 24'
hand.score
puts hand.points

hand = CribHand.new([[2, 'h'], [2, 's'], [2, 'c'], [3, 'd'], [3, 's']])
print hand.hand
puts ' score should be 8'
hand.score
puts hand.points

hand = CribHand.new([[3, 'h'], [3, 's'], [4, 'c'], [5, 'd'], [6, 's']])
print hand.hand
puts ' score should be 14'
hand.score
puts hand.points
