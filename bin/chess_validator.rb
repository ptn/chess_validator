require_relative "../lib/chess_validator"

board = File.read(ARGV[0])
moves = File.read(ARGV[1])
validations = ChessValidator.validate(board, moves)

LABELS = { true => "LEGAL", false => "ILLEGAL" }
results = validations.map { |val| LABELS[val] }

puts results.join("\n")
