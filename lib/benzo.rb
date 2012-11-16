require "benzo/version"
require 'awesome_print'
require 'cocaine'

class Benzo

  attr_accessor :command, :options_map
  attr_accessor :line, :vars

  def self.line(command, options_map)
    b = Benzo.new(command, options_map)
    line = b.to_cocaine

    b = nil
    line
  end

  def map!
    @options_map.each do |k,v|
      sym = get_symbol(k)
      @line << k if v

      if sym
        @vars[sym] = v
      end
    end
  end

  def initialize(command, options_map)
    @command = command
    @options_map = options_map
    @line = []
    @vars = {}

    map!
  end

  def get_symbol(str)
    m = str.match /:(\w+)/
    :"#{m[1]}" if m
  end

  def to_cocaine
    ap @line
    ap @vars
    ::Cocaine::CommandLine.new(@command, @line.join(' '), @vars)
  end

end
