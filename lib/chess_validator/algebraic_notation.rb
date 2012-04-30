module ChessValidator
  #
  # Utilities to convert back and forth from algebraic notation to an array
  # representation of [row, column]
  #
  module AlgebraicNotation
    def self.from_coordinates(row, column)
      [(column + 97).chr, row + 1].join
    end

    def self.to_coordinates(algebraic)
      [algebraic[1].to_i - 1, algebraic[0].ord - 97]
    end

    def self.valid?(move)
      ('a'..'h') === move[0] && ('1'..'8') === move[1]
    end
  end
end
