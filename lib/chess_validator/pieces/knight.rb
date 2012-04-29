module ChessValidator
  module Pieces
    class Knight < Piece
      def initialize(color, position, board)
        super
        @movement_rule = Proc.new do |destination|
          column_diff, row_diff = diffs(destination)
          (column_diff == 2 && row_diff == 1) ||
            (column_diff == 1 && row_diff == 2)
        end
      end
    end
  end
end
