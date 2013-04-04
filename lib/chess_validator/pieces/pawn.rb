module ChessValidator
  module Pieces
    #
    # Keeps track of where "forward" is: black pawns advance by
    # decreasing it's row index and white ones, by increasing it.
    #
    # No en-passant capturing.
    #
    class Pawn < Piece

      def initialize(color, position, board)
        super
        @forward = @color == :b ? -1 : 1
      end

      private

      def movement_rule(destination)
        destination == front_square ||
          (can_capture? destination) ||
          (long_start? destination)
      end

      # Returns the algebraic notation for the square in front of this
      # pawn.
      def front_square
        column = @position[0]
        row = (@position[1].to_i + @forward).to_s
        column + row
      end

      # Tests if there's an enemy piece in either of the pawn's two
      # capture squares.
      def can_capture?(destination)
        occupant = @board[destination]
        !occupant.nil? && (enemy? occupant) &&
          destination[1] == (@position[1].to_i + @forward).to_s &&
          (destination[0].ord - @position[0].ord).abs == 1
      end

      # Tests if the destination is two squares away directly forward
      # and the pawn is at a starting rank.
      def long_start?(destination)
        return false if (@color == :b && @position[1] != "7") ||
          (@color == :w && @position[1] != "2")
        long_start_square = @position[0] + (@position[1].to_i + 2*@forward).to_s
        destination == long_start_square
      end
      
    end
  end
end
