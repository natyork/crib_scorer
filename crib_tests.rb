require 'rspec'
require_relative 'crib_hand'
require_relative 'card'

RSpec.describe CribHand do
  describe "#score" do
    subject(:score) { described_class.new(starter, hand).score }

    context "score to be 29" do
      let(:starter) { [Card.new(5, 'hearts')] }
      let(:hand) { [Card.new(5, 'spades'), Card.new(5, 'clubs'), Card.new(5, 'diamonds'), Card.new(11, 'hearts')] }
      let(:expected_points) { 29 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 4" do
      let(:starter) { [Card.new(13, 'hearts')] }
      let(:hand) { [Card.new(2, 'spades'), Card.new(4, 'spades'), Card.new(5, 'diamonds'), Card.new(12, 'spades')] }
      let(:expected_points) { 4 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 15" do
      let(:starter) { [Card.new(2, 'hearts')] }
      let(:hand) { [Card.new(2, 'spades'), Card.new(2, 'clubs'), Card.new(3, 'diamonds'), Card.new(4, 'spades')] }
      let(:expected_points) { 15 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 16" do
      let(:starter) { [Card.new(2, 'hearts')] }
      let(:hand) { [Card.new(3, 'spades'), Card.new(3, 'clubs'), Card.new(4, 'diamonds'), Card.new(4, 'spades')] }
      let(:expected_points) { 16 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 24" do
      let(:starter) { [Card.new(4, 'hearts')] }
      let(:hand) { [Card.new(4, 'spades'), Card.new(5, 'clubs'), Card.new(5, 'diamonds'), Card.new(6, 'spades')] }
      let(:expected_points) { 24 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 8" do
      let(:starter) { [Card.new(2, 'hearts')] }
      let(:hand) { [Card.new(2, 'spades'), Card.new(2, 'clubs'), Card.new(3, 'diamonds'), Card.new(3, 'spades')] }
      let(:expected_points) { 8 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 14" do
      let(:starter) { [Card.new(3, 'hearts')] }
      let(:hand) { [Card.new(3, 'spades'), Card.new(4, 'clubs'), Card.new(5, 'diamonds'), Card.new(6, 'spades')] }
      let(:expected_points) { 14 }
      it { expect(subject).to eq expected_points }
    end

    context "points add to 11" do
      let(:starter) { [Card.new(3, 'spades')] }
      let(:hand) { [Card.new(12, 'hearts'), Card.new(4, 'hearts'), Card.new(2, 'hearts'), Card.new(6, 'hearts')] }
      let(:expected_points) { 11 }
      it { expect(subject).to eq expected_points }
    end
  end
end
