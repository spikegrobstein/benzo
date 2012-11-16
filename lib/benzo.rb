require "benzo/version"
require 'cocaine'

class Benzo

  attr_accessor :command, :options_map
  attr_accessor :line, :vars

  def initialize(command, options_map)
    @command = command
    @options_map = options_map
    @line = []
    @vars = {}

    map!
  end

  # convenience method for creating a new Benzo object with the given
  # arguments and returning the Cocaine::Commandline
  def self.line(command, options_map)
    b = new(command, options_map)
    line = b.to_cocaine

    b = nil
    line
  end

  # convert this object into a Cocaine::CommandLine
  def to_cocaine
    ::Cocaine::CommandLine.new(@command, @line.join(' '), @vars)
  end

  private

  # iterate over the options map and build
  # this object's mapping.
  def map!
    @options_map.each do |k,v|
      sym = get_symbol(k)
      @line << k if v

      if sym
        @vars[sym] = v
      end
    end
  end

  # given a string, pull out the symbol
  # this is used to get the key for the variable to pass to cocaine.
  def get_symbol(str)
    m = str.match /:(\w+)/
    :"#{m[1]}" if m
  end


end
