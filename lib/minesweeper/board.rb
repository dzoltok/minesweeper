require "minesweeper/cell"

module Minesweeper
  class Board
    def initialize(rows, columns, mines)
      @rows = rows
      @columns = columns
      @mines = mines
    end

    def size
      @rows * @columns
    end

    def reset
      @grid = Array.new(@rows) { Array.new(@columns) { Cell.new } }
      @revealed_cells = 0
      place_mines
    end

    def print_board
      puts "#{(' ' * 3)}#{(1..@columns).map { |c| c.to_s.rjust(2).ljust(3) }.join('')}"
      @grid.each.with_index(1) do |row, index|
        print index.to_s.rjust(2).ljust(3)
        puts row.map { |cell| cell.display }.join('')
      end
    end

    def reveal(row, column)
      cell = @grid[row - 1][column - 1]
      reveal_cell(cell)
      if (cell.empty?)
        for i in -1..1
          for j in -1..1
            r = row + i
            c = column + j
            if (r >= 1 && r <= @rows && c >= 1 && c <= @columns && @grid[r - 1][c - 1].revealable?)
              reveal(r, c)
            end
          end
        end
      end
      return !cell.has_mine?
    end

    def reveal_cell(cell)
      if cell.revealable?
        cell.reveal
        if cell.has_mine?
          return false
        end
        @revealed_cells += 1
      end
      return true
    end

    def revealable?(row, column)
      cell = @grid[row - 1][column - 1]
      cell.revealable?
    end

    def flag(row, column)
      cell = @grid[row - 1][column - 1]
      flag_cell(cell)
    end

    def flag_cell(cell)
      cell.has_flag? ? cell.remove_flag : cell.place_flag
      return true
    end

    def flaggable?(row, column)
      cell = @grid[row - 1][column - 1]
      cell.flaggable?
    end

    def reveal_all
      hit_mine = false
      @grid.each do |row|
        row.each do |cell|
          success = reveal_cell(cell)
          if !success
            hit_mine = true
          end
        end
      end
      !hit_mine
    end

    def reveal_mines
      @grid.each do |row|
        row.each do |cell|
          reveal_cell(cell) if cell.has_mine?
        end
      end
    end

    def cells_remaining
      size - @mines - @revealed_cells
    end

    private

    def place_mines
      mines_placed = 0
      prng = Random.new
      while (mines_placed < @mines) do
        row = nil
        column = nil
        loop do
          row = prng.rand(@rows)
          column = prng.rand(@columns)
          break if !@grid[row][column].has_mine?
        end
        place_mine(row, column)
        mines_placed += 1
      end
    end

    def place_mine(row, column)
      @grid[row][column].place_mine
      for i in -1..1
        for j in -1..1
          r = row + i
          c = column + j
          if (r >= 0 && r < @rows && c >= 0 && c < @columns)
            @grid[r][c].increment
          end
        end
      end
    end

  end
end
