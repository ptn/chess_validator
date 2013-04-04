module ChessValidator
  module Pieces
    class Bishop < Piece
      private

      def movement_rule(destination)
        (in_diagonal? destination) && !(obstacles? destination)
      end

      def in_diagonal?(destination)
        column_diff, row_diff = diffs(destination)
        column_diff == row_diff
      end

      # Recursively check if there are obstacles in the diagonal
      # connecting two squares.
      def obstacles?(destination,
                     current=@position,
                     column_direction=nil,
                     row_direction=nil)
        column_direction = default_column_direction(destination) unless column_direction
        row_direction = default_row_direction(destination) unless row_direction

        return false if current == destination
        return true unless current == @position || @board[current].nil?

        next_column = (current[0].ord + column_direction).chr
        next_row = (current[1].to_i + row_direction).to_s
        next_position = next_column + next_row
        obstacles? destination, next_position, column_direction, row_direction
      end

      def default_column_direction(destination)
        @position[0].ord - destination[0].ord < 0 ? 1 : -1
      end

      def default_row_direction(destination)
        @position[1].to_i - destination[1].to_i < 0 ? 1 : -1
      end
    end
  end
end
