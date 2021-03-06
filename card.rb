# Card creates a new card and provides a method to determine points
# for  each card
class Card
  attr_reader :value, :suit

  FACE_CARD = [11, 12, 13].freeze
  FACE_AS_TEN = 10

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def jack?
    value == 11
  end

  def points
    if FACE_CARD.include? value
      FACE_AS_TEN
    else
      value
    end
  end
end
