module ChessValidator
  class Board
    # Raised when a board is asked to validate a move that is not in algebraic
    # notation.
    class InvalidMove < Exception
      def self.for_origin(origin)
        new("Origin move '#{origin}' is not in valid algebraic notation")
      end

      def self.for_destination(destination)
        new("Destination move '#{destination}' is not in valid algebraic notation")
      end

      def self.for_indexing(index)
        new("Cannot retrieve piece at '#{index}' - invalid algebraic notation")
      end
    end
  end
end
