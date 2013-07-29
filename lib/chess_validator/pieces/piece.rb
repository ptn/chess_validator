module ChessValidator
  module Pieces

    #
    # Implements a basic, abstract chess piece.
    #
    # This piece can move to any square on the board provided that
    # said square is either empty or occupied by an enemy piece - this
    # guy teleports. It's the subclass' responsibility to provide the
    # movement rules in the form of the #movement_rule private method.
    #
    # Instance variables:
    #
    # * @color : a one-letter symbol, :b for black and :w for white.
    #
    # * @position : a two-char string representing the position of the
    # piece on the board in algebraic notation.
    #
    # * @board : a board object; see Chess::Board class.
    #
    # Instance methods:
    #
    # * valid_move? : evaluates if the given destination square is
    # valid according to the piece's movement rules.
    #
    #
    # Example Usage
    #
    #   class MyCustomPiece < Piece
    #     private
    #
    #     def movement_rule(destination)
    #       # The implementation of this is specific to each piece.
    #       am_i_allowed_there? destination
    #     end
    #   end
    #
    class Piece

      COLORS = {b: "black", w: "white"}

      attr_accessor :color
      attr_reader :position

      def initialize(color, position, board, &blk)
        @color = color
        @position = position
        @board = board
      end

      #
      # Checks if the destination square is empty or occuppied by an enemy
      # piece.
      #
      def valid_move?(destination)
        occupant = @board[destination]
        result = false
        if occupant.nil? || (enemy? occupant)
          result = movement_rule(destination)
        end

        result
      end

      def enemy?(piece)
        piece.color != @color
      end

      def enemy_color
        @color == :b ? :w : :b
      end

      def to_s
        [COLORS[@color],
         self.class.name.split('::').last,
         "at",
         @position
        ].join(" ")
      end

      private

      # Concrete pieces must override this to return true if the destination is
      # valid for that given piece type and false otherwise.
      def movement_rule(destination)
        true
      end

      # Utility to calculate the distance between the current position
      # and a destination square.
      def diffs(destination)
        column_diff = (@position[0].ord - destination[0].ord).abs
        row_diff = (@position[1].to_i - destination[1].to_i).abs
        return [column_diff, row_diff]
      end
    end
  end
end
