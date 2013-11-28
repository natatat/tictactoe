class TicTacToe

  def initialize
    @board = Array.new(9)
    @game_done = false
    @next_player = "x"
    @x_moves = []
    @o_moves = []
  end

  def run!
    puts "Time for some TicTacToe!"
    puts "------------------------"
    print_board

    play
  end

  def play
    unless game_done?
      if @next_player == "x"
        user_move
      else
        computer_move
      end
    else
      who_won?
    end
  end

  def who_won?
    print_board
    if @winner
      puts "#{@winner} has won!"
    else
      puts "It's a Draw!"
    end
  end

  def user_move
    puts "Pick your move:"
    move = gets.chomp.to_i - 1

    if @board[move] == nil
      @current_player = "The user"
      @next_player = "o"
      @board[move] = "x"
      @x_moves << move
    else
      puts "That position is not empty."
    end

    play
  end

  def computer_move
    @current_player = "The computer"
    @next_player = "x"

    puts "The computer's move:"
    @board[get_next_move] = "o"
    print_board
    play
  end

  def get_next_move
    if @board.compact.size == 1
      move = play_center || play_corner
      @o_moves << move
      move
    else
      run_algorithm
    end
  end

  def play_center
    puts "center"
    @board[4].nil? ? 4 : false
  end

  def play_corner
    puts "corner"
    if @board[0].nil? || @board[2].nil? || @board[6].nil? || @board[8].nil?
      (possibilities & [0,2,6,8]).sample
    else
      false
    end
  end

  def win
    puts "win"
    move_to_win = nil
    @possible_wins.each do |array|
      possible_win = array - @o_moves
      if possible_win.size == 1 && @board[possible_win.first].nil?
        move_to_win = possible_win.first
      end
    end
    move_to_win
  end

  def block
    puts "block"
    move_to_block = nil
    @possible_wins.each do |array|
      possible_lose = array - @x_moves
      if possible_lose.size == 1 && @board[possible_lose.first].nil?
        move_to_block = possible_lose.first
      end
    end
    move_to_block
  end

  def fork
    puts "fork"
    if (@board[0] == "x" && @board[8] == "x") || (@board[2] == "x" && @board[6] == "x")
      (possibilities & [1,3,5,7]).sample
    elsif (@board[1] == "x" && @board[8] == "x") || (@board[1] == "x" && @board[6] == "x")
      (possibilities & [0..3]).sample
    elsif (@board[0] == "x" && @board[7] == "x") || (@board[2] == "x" && @board[7] == "x")
      (possibilities & [5..8]).sample
    else
      false
    end
  end

  def run_algorithm
    win || block || fork || play_center || play_corner || possibilities.sample
  end

  def possibilities
    possibilities = []
    @board.each_with_index do |element, index|
      if element.nil?
        possibilities << index
      end
    end
    possibilities
  end

  def print_board
    puts "---------"
    puts "[#{@board[0]||1}][#{@board[1]||2}][#{@board[2]||3}]"
    puts "[#{@board[3]||4}][#{@board[4]||5}][#{@board[5]||6}]"
    puts "[#{@board[6]||7}][#{@board[7]||8}][#{@board[8]||9}]"
    puts "---------"
  end

  def game_done?
    winner?
    @game_done
  end

  def winner?
    @possible_wins = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6]
    ]

    @possible_wins.each do |possible|
      winning_combo = (@board[possible[0]] == @board[possible[1]] && @board[possible[1]] == @board[possible[2]])
      if @board[possible[0]] != nil && winning_combo
        @winner = @current_player
        @game_done = true
      elsif @board.compact.size == 9 && !winning_combo
        @winner = nil
        @game_done = true
      end
    end
  end
end

game = TicTacToe.new
game.run!