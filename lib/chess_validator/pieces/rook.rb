module ChessValidator
  module Pieces
    class Rook < Piece
      def initialize(color, position, board)
        super
        @movement_rule = Proc.new do |destination|
          if @position[0] == destination[0]
            obstacles_in_column? destination
          elsif @position[1] == destination[1]
            obstacles_in_row? destination
          else
            false
          end
        end
      end

      private

      # Test if the squares in the same column in between this rook
      # and the destination are empty.
      def obstacles_in_column?(destination)
        column = @position[0]
        start = @position[1].to_i
        finish = destination[1].to_i
        start, finish = adjust(start, finish)
        (start..finish).each do |row|
          return false unless @board[column + row.to_s].nil?
        end
        true
      end

      # Test if the squares in the same row in between this rook and
      # the destination are empty.
      def obstacles_in_row?(destination)
        row = @position[1]
        start = @position[0].ord - 97
        finish = destination[0].ord - 97
        start, finish = adjust(start, finish)
        (start..finish).each do |index|
          column = (index + 97).chr
          return false unless @board[column + row].nil?
        end
        true
      end

      # Sorts start and finish in ascendant order and omits self and
      # the destination from the test for obstacles.
      def adjust(start, finish)
        direction = start - finish < 0 ? 1 : -1
        start, finish = start + direction, finish - direction
        start, finish = finish, start if finish < start
        [start, finish]
      end
    end
  end
end
