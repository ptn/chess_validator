require_relative "../lib/chess_validator"

board_file = File.open(ARGV[0])
raw_board = board_file.read
board_file.close

moves_file = File.open(ARGV[1])
raw_moves = moves_file.read
moves_file.close

ChessValidator.validate raw_board, raw_moves
