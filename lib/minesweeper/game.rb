require 'minesweeper/board'

module Minesweeper
  class Game

    ACTION_MENU = {
      prompt: "Select action",
      options: [
        { display: '[R]eveal', command: 'r' },
        { display: '[F]lag/Unflag', command: 'f' },
        { display: 'Reveal [A]ll', command: 'a' },
      ],
      invalid: "Invalid action, please try again"
    }

    def initialize(rows, columns, mines)
      @rows = rows
      @columns = columns
      @board = Board.new(rows, columns, mines)
    end

    def play
      @board.print_board
      success = true
      loop do
        action, row, column = nil
        loop do
          action, row, column = collect_move
          break if ((action == 'r' && @board.revealable?(row, column)) || (action == 'f' && @board.flaggable?(row, column)) || (action == 'a'))
          puts "That action cannot be performed on that cell, please try again."
        end
        if (action == 'r')
          success = @board.reveal(row, column)
        elsif (action == 'f')
          success = @board.flag(row, column)
        elsif (action == 'a')
          puts "This will reveal all un-flagged cells, are you sure you want to do this? (Y/N)"
          confirmation = gets.chomp.downcase
          if (confirmation == 'y')
            success = @board.reveal_all
          end
        end
        @board.reveal_mines if !success
        @board.print_board
        break if @board.cells_remaining == 0 || !success
      end
      return (@board.cells_remaining == 0 && success)
    end

    def reset
      @board.reset
    end

    private

    def collect_move
      action = Minesweeper.display_menu(ACTION_MENU)
      unless (action == 'a')
        row = Minesweeper.get_number('Enter the row of the cell you wish to reveal/flag', 1, @rows, 'Invalid row, please try again')
        column = Minesweeper.get_number('Enter the column of the cell you wish to reveal/flag', 1, @columns, 'Invalid column, please try again')
      end
      [ action, row, column ]
    end
  end
end
