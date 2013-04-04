require_relative "algebraic_notation"
require_relative "board/builds_matrices"

module ChessValidator
  #
  # Represents a chess board and the pieces set on it.
  #
  class Board
    attr_reader :matrix, :algebraic_notation_lib

    def initialize(input, algebraic_notation_lib=AlgebraicNotation)
      @algebraic_notation_lib = algebraic_notation_lib
      @matrix = BuildsMatrices.new(self).build(input)
    end

    #
    # Return the piece at the given position.
    #
    # Coordinates are given in algebraic notation.
    # Example invocation: board["f6"]  # => a piece object
    #
    def [](algebraic)
      real_row, real_column = algebraic_notation_lib.to_coordinates(algebraic)
      # Careful: algebraic notation indexes the board from bottom to top.
      reversed_row = 7 - real_row
      index = 8 * reversed_row + real_column
      matrix[index]
    end

    def valid_move?(origin, destination)
      !!(self[origin] && (self[origin].valid_move? destination))
    end

    # Return an array of all pieces of the given color.
    def set(color)
      color == :w ? whites : blacks
    end
    
    # Return an array of all white pieces.
    def whites
      matrix.select { |piece| piece && piece.color == :w }
    end

    # Return an array of all black pieces.
    def blacks
      matrix.select { |piece| piece && piece.color == :b }
    end
  end
end
