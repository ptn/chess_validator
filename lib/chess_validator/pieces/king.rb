module ChessValidator
  module Pieces
    class King < Piece
      private

      def movement_rule(destination)
        (adjacent? destination) && !(check? destination)
      end

      def adjacent?(destination)
        column_diff, row_diff = diffs(destination)
        column_diff < 2 && row_diff < 2
      end

      def check?(destination)
        @board.set(enemy_color).each do |enemy|
          return true if enemy.valid_move? destination
        end
        false
      end
    end
  end
end
