require "benzo/version"
require 'cocaine'

class Benzo

  attr_accessor :command, :options_map
  attr_accessor :line, :vars

  def initialize(command, options_map={})
    @command = command
    @options_map = options_map
    @line = []
    @vars = {}
  end

  # given a +command+ and +options_map+, interpolate the variables and
  # run the command.
  # returns the output as a string (as returned from Cocaine)
  def self.run!(command, options_map)
    b = new(command, options_map)
    r = b.run
    b = nil # dealocate object
    r
  end

  # given a +command+ and +options_map+, interpolate the variables and
  # return the command that will be run as a string.
  def self.command!(command, options_map)
    b = new(command, options_map)
    c = b.command
    b = nil # dealocate object
    c
  end

  # run the +Cocaine::CommandLine+ command and return the output.
  def run
    cocaine.run(@vars)
  end

  # return the +Cocaine::CommandLine+ command as a string
  def command
    cocaine.command(@vars)
  end

  # map the variables and return a +Cocaine::CommandLine+ object
  def cocaine
    map!
    ::Cocaine::CommandLine.new(@command, @line.join(' '), @vars)
  end

  private

  # iterate over the options map and build
  # this object's mapping.
  def map!
    # re-initialize the state
    @line = []
    @vars = {}

    @options_map.each do |k,v|
      sym = if k.is_a? Symbol
        k
      else
        @line << k if v
        sym = get_symbol(k)
      end

      if sym
        @vars[sym] = v
      end
    end
  end

  # given a string, pull out the symbol
  # this is used to get the key for the variable to pass to cocaine.
  # returns nil if no symbol found
  # raises an ArgumentError if the symbol isn't well-formed (has bad chars)
  def get_symbol(str)
    m = str.match /:(\S+)/

    return nil unless m
    sym = m[1]

    raise ArgumentError if sym.match(/[^a-z0-9_]/i)

    :"#{sym}"
  end


end
