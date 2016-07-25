module Minesweeper
  class Cell
    def initialize
      @revealed = false
      @mined = false
      @flagged = false
      @value = 0
    end

    def value
      @value
    end

    def empty?
      @value == 0 && !has_mine?
    end

    def increment
      unless has_mine?
        @value += 1
      end
    end

    def has_mine?
      !!@mined
    end

    def place_mine
      @mined = true
    end

    def remove_mine
      @mined = false
    end

    def has_flag?
      !!@flagged
    end

    def flaggable?
      !revealed?
    end

    def place_flag
      @flagged = true
    end

    def remove_flag
      @flagged = false
    end

    def revealed?
      !!@revealed
    end

    def revealable?
      !revealed? & !has_flag?
    end

    def reveal
      @revealed = true
    end

    def hide
      @revealed = false
    end

    def display
      if has_flag?
        print "[!]"
      elsif !revealed?
        print "[-]"
      elsif has_mine?
        print "[*]"
      elsif empty?
        print "[ ]"
      else
        print "[#{value}]"
      end
    end
  end
end
