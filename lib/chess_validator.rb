require_relative "chess_validator/board"

module ChessValidator
  def self.validate(raw_board, raw_moves)
    board = Board.new(raw_board)
    moves(raw_moves) do |origin, destination|
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
