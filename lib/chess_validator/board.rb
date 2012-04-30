require_relative "algebraic_notation"
require_relative "pieces/piece"
require_relative "pieces/pawn"
require_relative "pieces/rook"
require_relative "pieces/knight"
require_relative "pieces/bishop"
require_relative "pieces/queen"
require_relative "pieces/king"

module ChessValidator
  #
  # Represents a chess board and the pieces set on it.
  #
  class Board

    EMPTY_SQUARE = '--'
    
    PIECES_DICT = {
      "P" => Pieces::Pawn,
      "R" => Pieces::Rook,
      "N" => Pieces::Knight,
      "B" => Pieces::Bishop,
      "Q" => Pieces::Queen,
      "K" => Pieces::King,
    }


    attr_reader :matrix

    def initialize(input)
      @matrix = parse_input(input)
    end

    #
    # Return the piece at the given position.
    #
    # Coordinates are given in algebraic notation.
    # Example invocation: board["f6"]  # => a piece object
    #
    def [](algebraic)
      real_row, real_column = AlgebraicNotation.to_coordinates(algebraic)
      # Careful: algebraic notation indexes the board from bottom to top.
      reversed_row = 7 - real_row
      index = 8 * reversed_row + real_column
      @matrix[index]
    end

    def valid_move?(origin, destination)
      self[origin] && (self[origin].valid_move? destination)
    end

    # Return an array of all pieces of the given color.
    def set(color)
      color == :w ? whites : blacks
    end
    
    # Return an array of all white pieces.
    def whites
      @matrix.select { |piece| piece && piece.color == :w }
    end

    # Return an array of all black pieces.
    def blacks
      @matrix.select { |piece| piece && piece.color == :b }
    end

    private

    #
    # Parse the file input into a unidimensional array.
    #
    # The board is read from top to bottom! So the first set of 8
    # elements constitute row 8, the next one is row 7, and so on.
    #
    def parse_input(input)
      matrix = []
      row = 7
      column = 0
      input.split.each do |raw_piece|
        matrix << build_piece(raw_piece, row, column)
        column += 1
        if column == 8
          column = 0
          row -= 1
        end
      end
      matrix
    end

    # Instantiate the correct subclass of Piece.
    def build_piece(raw_piece, row, column)
      if raw_piece == EMPTY_SQUARE
        piece = nil
      else
        color = raw_piece[0].to_sym
        position = AlgebraicNotation.from_coordinates(row, column)
        cls = PIECES_DICT[raw_piece[1]]
        piece = cls.new(color, position, self)
      end
      piece
    end
  end
end
