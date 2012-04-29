module ChessValidator
  module Pieces
    class King < Piece
      def initialize(color, position, board)
        super
        @movement_rule = Proc.new do |destination|
          (adjacent? destination) && !(check? destination)
        end
      end

      private

      def adjacent?(destination)
        column_diff, row_diff = diffs(destination)
        column_diff < 2 && row_diff < 2
      end

      def check?(destination)
        enemy_color = @color == :b ? :w : :b
        @board.set(enemy_color).each do |enemy|
          return true if enemy.valid_move? destination
        end
        false
      end
    end
  end
end
