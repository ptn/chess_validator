require_relative "chess_validator/board"

module ChessValidator
  def self.validate(raw_board, raw_moves, boardcls=Board)
    board = boardcls.new(raw_board)
    moves(raw_moves).map { |origin, dest| board.valid_move? origin, dest }
  end

  private
  
  def self.moves(input)
    input.each_line.map { |line| line.split }
  end
end
