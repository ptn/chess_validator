module Chess
  
  module Pieces

    #
    # Implements a basic, abstract chess piece.
    #
    # This piece can move to any square on the board provided that
    # said square is either empty or occupied by an enemy piece - this
    # guy teleports. It's the subclass' responsibility to provide the
    # movement rules in the form of the @movement_rule instance
    # variable.
    #
    # Instance variables:
    #
    # * @color : a one-letter symbol, :b for black and :w for white.
    #
    # * @position : a two-char string representing the position of the
    # piece on the board in algebraic notation.
    #
    # * @board : a board object; see Chess::Board class.
    #
    # * @movement_rule : block that takes a destination square and
    # * returns true if it's valid for the given piece and false
    # * otherwise.
    #
    # Instance methods:
    #
    # * valid_move? : evaluates if the given destination square is
    # valid according to the piece's movement rules.
    #
    class Piece

      COLORS = {b: "black", w: "white"}

      attr_accessor :color, :movement_rule
      attr_reader :position

      def initialize(color, position, board, &blk)
        @color = color
        @position = position
        @board = board
        @movement_rule = blk || Proc.new { |destination| true }
      end

      #
      # Checks if the destination square is empty or occuppied by an
      # enemy piece.
      #
      # Concrete pieces must set the instance variable @movement_rule
      # in it's constructor to be a block that returns true if the
      # destination is valid for that given piece type and false
      # otherwise.
      #
      def valid_move?(destination)
        return false unless valid_algebraic? destination
        occupant = @board[destination]
        result = false
        if occupant.nil? || (enemy? occupant)
          result = @movement_rule.call(destination)
        end
        result
      end

      def enemy?(piece)
        piece.color != @color
      end

      def to_s
        [COLORS[@color],
         self.class.name.split('::').last,
         "at",
         @position
        ].join(" ")
      end

      private

      def valid_algebraic?(move)
        ('a'..'h') === move[0] && ('1'..'8') === move[1]
      end

      # Utility to calculate the distance between the current position
      # and a destination square.
      def diffs(destination)
        column_diff = (@position[0].ord - destination[0].ord).abs
        row_diff = (@position[1].to_i - destination[1].to_i).abs
        return [column_diff, row_diff]
      end
    end


    #
    # Keeps track of where "forward" is: black pawns advance by
    # decreasing it's row index and white ones, by increasing it.
    #
    # No en-passant capturing.
    #
    class Pawn < Piece

      def initialize(color, position, board)
        super
        @forward = @color == :b ? -1 : 1
        @movement_rule = Proc.new do |destination|
          destination == front_square ||
            (can_capture? destination) ||
            (long_start? destination)
        end
      end

      private

      # Returns the algebraic notation for the square in front of this
      # pawn.
      def front_square
        column = @position[0]
        row = (@position[1].to_i + @forward).to_s
        column + row
      end

      # Tests if there's an enemy piece in either of the pawn's two
      # capture squares.
      def can_capture?(destination)
        occupant = @board[destination]
        !occupant.nil? && (enemy? occupant) &&
          destination[1] == (@position[1].to_i + @forward).to_s &&
          (destination[0].ord - @position[0].ord).abs == 1
      end

      # Tests if the destination is two squares away directly forward
      # and the pawn is at a starting rank.
      def long_start?(destination)
        return false if (@color == :b && @position[1] != "7") ||
          (@color == :w && @position[1] != "2")
        long_start_square = @position[0] + (@position[1].to_i + 2*@forward).to_s
        destination == long_start_square
      end
      
    end
    

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
        @movement_rule = Proc.new do |destination|
          (@bishop.valid_move? destination) || (@rook.valid_move? destination)
        end
      end
    end

    
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
  

  #
  # Represents a chess board and the pieces set on it.
  #
  class Board

    EMPTY_SQUARE = '--'
    
    PIECES_DICT = {
      "P" => Pieces::Pawn,
      "R" => Pieces::Rook,
      "N" => Pieces::Knight,
      "B" => Pieces::Bishop,
      "Q" => Pieces::Queen,
      "K" => Pieces::King,
    }


    attr_reader :matrix

    def initialize(input)
      @matrix = parse_input(input)
    end

    #
    # Return the piece at the given position.
    #
    # Coordinates are given in algebraic notation.
    # Example invocation: board["f6"]  # => a piece object
    #
    def [](algebraic)
      real_row, real_column = algebraic_to_coordinates(algebraic)
      # Careful: algebraic notation indexes the board from bottom to top.
      reversed_row = 7 - real_row
      index = 8 * reversed_row + real_column
      @matrix[index]
    end

    def valid_move?(origin, destination)
      self[origin] && (self[origin].valid_move? destination)
    end

    # Return an array of all pieces of the given color.
    def set(color)
      color == :w ? whites : blacks
    end
    
    # Return an array of all white pieces.
    def whites
      @matrix.select { |piece| piece && piece.color == :w }
    end

    # Return an array of all black pieces.
    def blacks
      @matrix.select { |piece| piece && piece.color == :b }
    end

    private

    #
    # Parse the file input into a unidimensional array.
    #
    # The board is read from top to bottom! So the first set of 8
    # elements constitute row 8, the next one is row 7, and so on.
    #
    def parse_input(input)
      matrix = []
      row = 7
      column = 0
      input.split.each do |raw_piece|
        matrix << build_piece(raw_piece, row, column)
        column += 1
        if column == 8
          column = 0
          row -= 1
        end
      end
      matrix
    end

    # Instantiate the correct subclass of Piece.
    def build_piece(raw_piece, row, column)
      if raw_piece == EMPTY_SQUARE
        piece = nil
      else
        color = raw_piece[0].to_sym
        position = coordinates_to_algebraic(row, column)
        cls = PIECES_DICT[raw_piece[1]]
        piece = cls.new(color, position, self)
      end
      piece
    end

    def coordinates_to_algebraic(row, column)
      [(column + 97).chr, row + 1].join
    end

    def algebraic_to_coordinates(algebraic)
      [algebraic[1].to_i - 1, algebraic[0].ord - 97]
    end

  end
end

module MovesValidator
  def self.validate(raw_board, raw_moves)
    board = Chess::Board.new(raw_board)
    moves raw_moves do |origin, destination|
      puts (board.valid_move? origin, destination) ? "LEGAL" : "ILLEGAL"
    end
  end

  private
  
  def self.moves(input)
    input.each_line do |line|
      yield line.split
    end
  end
end

board_file = File.open(ARGV[0])
raw_board = board_file.read
board_file.close
moves_file = File.open(ARGV[1])
raw_moves = moves_file.read
moves_file.close
MovesValidator.validate raw_board, raw_moves
