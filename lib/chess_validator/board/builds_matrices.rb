require_relative "../algebraic_notation"
require_relative "../pieces/piece"
require_relative "../pieces/pawn"
require_relative "../pieces/rook"
require_relative "../pieces/knight"
require_relative "../pieces/bishop"
require_relative "../pieces/queen"
require_relative "../pieces/king"

module ChessValidator
  class Board
    class BuildsMatrices
      EMPTY_SQUARE = '--'
      
      PIECES_HASH = {
        :P => Pieces::Pawn,
        :R => Pieces::Rook,
        :N => Pieces::Knight,
        :B => Pieces::Bishop,
        :Q => Pieces::Queen,
        :K => Pieces::King,
      }

      attr_reader :board, :algebraic_notation_lib

      def initialize(board, algebraic_notation_lib=AlgebraicNotation)
        @board = board
        @algebraic_notation_lib = algebraic_notation_lib
      end

      #
      # Parse the file input into a unidimensional array.
      #
      # The board is read from top to bottom! So the first set of 8
      # elements constitute row 8, the next one is row 7, and so on.
      #
      def build(input)
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

      private

      # Instantiate the correct subclass of Piece.
      def build_piece(raw_piece, row, column)
        if raw_piece == EMPTY_SQUARE
          piece = nil
        else
          color = raw_piece[0].to_sym
          position = algebraic_notation_lib.from_coordinates(row, column)
          cls = PIECES_HASH[raw_piece[1].to_sym]
          piece = cls.new(color, position, board)
        end

        piece
      end
    end
  end
end
