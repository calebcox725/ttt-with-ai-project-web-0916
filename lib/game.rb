class Game
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

  attr_accessor :board, :player_1, :player_2

  def initialize(
    player_1 = Players::Human.new("X"),
    player_2 = Players::Human.new("O"),
    board = Board.new
    )

    self.player_1 = player_1
    self.player_2 = player_2
    self.board = board
  end

  def current_player
    board.turn_count.even? ? player_1 : player_2
  end

  def is_winner?(token)
    WIN_COMBINATIONS.any? do |combination|
      token == board.cells[combination[0]] &&
        token == board.cells[combination[1]] &&
        token == board.cells[combination[2]]
    end
  end

  def winner
    if is_winner?("X")
      "X"
    elsif is_winner?("O")
      "O"
    else
      nil
    end
  end

  def over?
    draw? || won?
  end

  def won?
    !winner.nil?
  end

  def draw?
    board.full? && !won?
  end

  def turn
    puts "\n#{current_player.token}'s turn:"
    board.display
    move = current_player.move(board)
    
    if !board.valid_move?(move)
      puts "\nInvalid selection, try again."
      turn
    else
      board.update(move, current_player)
    end
  end

  def play
    while !over?
      turn
    end

    if won?
      puts ""
      puts "Congratulations #{winner}!"
    else
      puts ""
      puts "Cats Game!"
    end
    board.display
  end

  def start(first_game = true)
    if first_game
      puts "\n*************************"
      puts " Welcome to Tic-Tac-Toe!"
      puts "*************************"
    end

    board.reset!
    players_select
    play
    play_again_select
  end

  def players_select
    puts "\nHow many players? (0, 1, or 2)"
    humans = gets.chomp

    if humans == "0"
      self.player_1 = Players::Computer.new("X")
      self.player_2 = Players::Computer.new("O")
    elsif humans == "1"
      human_vs_computer_select
    elsif humans == "2"
      self.player_1 = Players::Human.new("X")
      self.player_2 = Players::Human.new("O")
    else
      puts "\nInvalid selection,try again."
      players_select
    end
  end

  def human_vs_computer_select 
    puts "\nWould you like to be X or O? (X goes first!)"
    selection = gets.chomp

    if selection == "X"
      self.player_1 = Players::Human.new("X")
      self.player_2 = Players::Computer.new("O")
    elsif selection == "O"
      self.player_1 = Players::Computer.new("X")
      self.player_2 = Players::Human.new("O")
    else
      puts "\nInvalid selection, try again."
      human_vs_computer_select
    end
  end

  def play_again_select
    puts "\nPlay again? (y/n)"
    selection = gets.chomp

    if selection == "y"
      start(false)
    elsif selection == "n"
      puts "\nOK, bye!"
    else
      puts "\nInvalid selection, try again."
      play_again_select
    end
  end
end