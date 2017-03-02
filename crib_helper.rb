class CribHelper

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

  def run?(arr)
    prev_num = arr[0]
    arr[1, arr.length].each do |current_num|
      return false if prev_num + 1 != current_num
      prev_num = current_num
    end
    return true
  end

  def eq_arr_values?(arr)
    prev_num = arr[0]
    arr[1, arr.length].each do |current_num|
      return false if prev_num != current_num
      prev_num = current_num
    end
    return true
  end
end
