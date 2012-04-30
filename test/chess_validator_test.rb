require 'minitest/autorun'

require_relative 'test_helper'
require_relative '../lib/chess_validator'

describe ChessValidator do
  it "should validate a simple chess board" do
    board   = File.read("data/simple_board.txt")
    moves   = File.read("data/simple_moves.txt")

    expected = [
      true,
      true,
      false,
      true,
      true,
      false,
      false,
      true,
      true,
      false,
      true,
      false
    ]

    ChessValidator.validate(board, moves).must_equal expected
  end

  it "should validate a complex chess board" do
    board   = File.read("data/complex_board.txt")
    moves   = File.read("data/complex_moves.txt")

    expected = [
      true,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      true,
      true,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ]

    ChessValidator.validate(board, moves).must_equal expected
  end
end
