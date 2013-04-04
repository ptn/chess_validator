module ChessValidator
  module Pieces
    #
    # Moves like the combination of a rook and a bishop, and that's
    # how it's implemented. For every destination, it is first tested
    # as if it were a bishop and then as if it were a rook.
    #
    class Queen < Piece
      def initialize(color, position, board)
        super
        @rook = Rook.new(color, position, board)
        @bishop = Bishop.new(color, position, board)
      end

      private

      def movement_rule(destination)
        (@bishop.valid_move? destination) || (@rook.valid_move? destination)
      end
    end
  end
end
