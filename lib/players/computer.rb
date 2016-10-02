module Players
  class Computer < Player
    WIN_COMBINATIONS = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [6,4,2]
    ]
    ALL_POSITIONS = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    CENTER = ["5"]
    CORNERS = ["1", "3", "7", "9"]
    SIDES = ["2", "4", "6", "8"]

    attr_accessor :board, :opponent_token

    def move(board)
      self.board = board
      self.opponent_token ||= token_check(token)

      puts "Moving..."
      calculate_move   
    end

    def token_check(token)
      token == "O" ? "X" : "O"
    end

    def calculate_move
      return win_move if !win_move.nil?
      return block_move if !block_move.nil?
      return fork_block_move if !fork_block_move.nil?
      return center_move if !center_move.nil?
      return opposite_corner_move if !opposite_corner_move.nil?
      return corner_movey if !corner_movey.nil?
      return side_move if !side_move.nil?
    end

    def winner_finder(token)
      WIN_COMBINATIONS.each_with_object([]) do |combination, winners|
        if board.cells[combination[0]] == token && board.cells[combination[1]] == token
          winners << "#{combination[2] + 1}"
        elsif board.cells[combination[1]] == token && board.cells[combination[2]] == token
          winners << "#{combination[0] + 1}"
        elsif board.cells[combination[2]] == token && board.cells[combination[0]] == token
          winners << "#{combination[1] + 1}"
        end
      end
    end

    def win_move
      winners = winner_finder(token)
      move_list_validator(winners)
    end

    def block_move
      blockers = winner_finder(opponent_token)
      move_list_validator(blockers)
    end

    def fork_block_move
      fork_blockers = CORNERS.each_with_object([]) do |corner, blockers|
        corner_position = board.position(corner)
        opposite_corner_position = board.position(10 - corner.to_i)

        if corner_position == opponent_token && opposite_corner_position == opponent_token
          blockers << side_move
        end
      end

      move_list_validator(fork_blockers)
    end

    def center_move
      move_list_validator(CENTER) if board.turn_count == 1
    end

    def opposite_corner_move
      opposite_corners = CORNERS.find_all do |corner|
        opposite_corner = 10 - corner.to_i
        board.taken?(opposite_corner)
      end

      move_list_validator(opposite_corners)
    end

    def corner_movey
      move_list_validator(CORNERS)    
    end

    def side_move
      move_list_validator(SIDES)
    end

    def move_list_validator(moves)
      moves.shuffle!
      moves.detect {|move| board.valid_move?(move)}
    end

  end
end
