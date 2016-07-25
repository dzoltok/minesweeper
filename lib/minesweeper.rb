require "minesweeper/game"

module Minesweeper

  MAIN_MENU = {
    message: "What would you like to do?",
    options: [
      { display: '[N]ew Game', command: 'n' },
      { display: '[Q]uit', command: 'q' }
    ],
    invalid: "Invalid action, please try again"
  }

  DIFFICULTY_MENU = {
    message: "Select your difficulty",
    options: [
      { display: '[B]eginner', command: 'b' },
      { display: '[I]ntermediate', command: 'i' },
      { display: '[E]xpert', command: 'e' },
      { display: '[C]ustom', command: 'c' },
    ],
    invalid: "Invalid difficulty, please try again"
  }

  def self.start
    puts '*** Welcome to Minesweeper! ***'
    game = nil

    loop do
      command = Minesweeper.display_menu(MAIN_MENU)
      break if command == 'q'
      if command == 'n'
        # Set up a new game
        difficulty = Minesweeper.display_menu(DIFFICULTY_MENU)
        game = nil
        case difficulty
        when 'b'
          rows = 8
          columns = 8
          mines = 10
        when 'i'
          rows = 16
          columns = 16
          mines = 40
        when 'e'
          rows = 16
          columns = 30
          mines = 99
        when 'c'
          rows = Minesweeper.get_number('Enter the number of rows for the grid', 8, 24, 'Invalid number of rows, please try again')
          columns = Minesweeper.get_number('Enter the number of columns for the grid', 8, 30, 'Invalid number of columns, please try again')
          mines = Minesweeper.get_number('Enter the number of mines for the grid', 10, (rows - 1) * (columns - 1), 'Invalid number of mines, please try again')
        end
        game = Game.new(rows, columns, mines)
      end

      game.reset
      result = game.play
      if (result)
        puts "Congratulations, you win!"
      else
        puts "Oh no, you hit a mine!"
      end
    end

    puts "Thanks for playing!"
  end

  def self.display_menu(menu)
    puts menu[:message]
    print "#{menu[:options].map { |o| o[:display] }.join(', ')}: "
    command = nil
    loop do
      command = gets.chomp.downcase
      break if menu[:options].map{ |o| o[:command] }.include?(command)
      print "#{menu[:invalid]}: "
    end
    command
  end

  def self.get_number(message, min, max, invalid)
    print "#{message} (#{min}-#{max}): "
    value = nil
    loop do
      value = gets.chomp.to_i
      break if value >= min && value <= max
      print "#{invalid}: "
    end
    value
  end
end
