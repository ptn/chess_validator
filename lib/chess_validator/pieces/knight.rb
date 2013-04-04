module ChessValidator
  module Pieces
    class Knight < Piece
      private

      def movement_rule(destination)
        column_diff, row_diff = diffs(destination)
        (column_diff == 2 && row_diff == 1) ||
          (column_diff == 1 && row_diff == 2)
      end
    end
  end
end
