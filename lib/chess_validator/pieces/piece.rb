module ChessValidator
  module Pieces

    #
    # Implements a basic, abstract chess piece.
    #
    # This piece can move to any square on the board provided that
    # said square is either empty or occupied by an enemy piece - this
    # guy teleports. It's the subclass' responsibility to provide the
    # movement rules in the form of the @movement_rule instance
    # variable.
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
    # * @movement_rule : block that takes a destination square and
    # * returns true if it's valid for the given piece and false
    # * otherwise.
    #
    # Instance methods:
    #
    # * valid_move? : evaluates if the given destination square is
    # valid according to the piece's movement rules.
    #
    class Piece

      COLORS = {b: "black", w: "white"}

      attr_accessor :color, :movement_rule
      attr_reader :position

      def initialize(color, position, board, &blk)
        @color = color
        @position = position
        @board = board
        @movement_rule = blk || Proc.new { |destination| true }
      end

      #
      # Checks if the destination square is empty or occuppied by an
      # enemy piece.
      #
      # Concrete pieces must set the instance variable @movement_rule
      # in it's constructor to be a block that returns true if the
      # destination is valid for that given piece type and false
      # otherwise.
      #
      def valid_move?(destination)
        return false unless AlgebraicNotation.valid? destination
        occupant = @board[destination]
        result = false
        if occupant.nil? || (enemy? occupant)
          result = @movement_rule.call(destination)
        end
        result
      end

      def enemy?(piece)
        piece.color != @color
      end

      def to_s
        [COLORS[@color],
         self.class.name.split('::').last,
         "at",
         @position
        ].join(" ")
      end

      private

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
