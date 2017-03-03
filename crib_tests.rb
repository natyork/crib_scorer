require 'rspec'
require File.expand_path('../crib_hand.rb', __FILE__)

RSpec.describe CribHand do
  subject(:total_points) { described_class.new(hand).total_points }

  context "points add to 29" do
    let(:hand) { [[5, 'h'], [5, 's'], [5, 'c'], [5, 'd'], [11, 'h']] }
    let(:expected_points) { 29 }
    it { expect(subject).to eq expected_points }
  end

  context "points add to 4" do
    let(:hand) { [[13, 'h'], [2, 's'], [4, 's'], [5, 'd'], [12, 's']] }
    let(:expected_points) { 4 }
    it { expect(subject).to eq expected_points }
  end

  context "points add to 15" do
    let(:hand) {[[2, 'h'], [2, 's'], [2, 'c'], [3, 'd'], [4, 's']]}
    let(:expected_points) { 15 }
    it { expect(subject).to eq expected_points }
  end

  context "points add to 16" do
    let(:hand) {[[2, 'h'], [3, 's'], [3, 'c'], [4, 'd'], [4, 's']]}
    let(:expected_points) { 16 }
    it { expect(subject).to eq expected_points }
  end

  context "points add to 24" do
    let(:hand) {[[4, 'h'], [4, 's'], [5, 'c'], [5, 'd'], [6, 's']]}
    let(:expected_points) { 24 }
    it { expect(subject).to eq expected_points }
  end

  context "points add to 8" do
    let(:hand) {[[2, 'h'], [2, 's'], [2, 'c'], [3, 'd'], [3, 's']] }
    let(:expected_points) { 8 }
    it { expect(subject).to eq expected_points }
  end

  context "points add to 14" do
    let(:hand) {[[3, 'h'], [3, 's'], [4, 'c'], [5, 'd'], [6, 's']]}
    let(:expected_points) { 14 }
    it { expect(subject).to eq expected_points }
  end
end
