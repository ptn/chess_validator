module ChessValidator
  module Pieces
    class Bishop < Piece
      def initialize(color, position, board)
        super
        @movement_rule = Proc.new do |destination|
          (in_diagonal? destination) && !(obstacles? destination)
        end
      end

      private

      def in_diagonal?(destination)
        column_diff, row_diff = diffs(destination)
        column_diff == row_diff
      end

      def obstacles?(destination)
        column_direction = @position[0].ord - destination[0].ord < 0 ? 1 : -1
        row_direction = @position[1].to_i - destination[1].to_i < 0 ? 1 : -1
        _obstacles? @position, destination, column_direction, row_direction
      end

      # Recursively check if there are obstacles in the diagonal
      # connecting two squares.
      def _obstacles?(current, destination, column_direction, row_direction)
        return false if current == destination
        return true unless current == @position || @board[current].nil?
        next_column = (current[0].ord + column_direction).chr
        next_row = (current[1].to_i + row_direction).to_s
        next_position = next_column + next_row
        _obstacles? next_position, destination, column_direction, row_direction
      end
    end
  end
end
