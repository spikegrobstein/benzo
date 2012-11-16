require "benzo/version"
require 'awesome_print'
require 'cocaine'

class Benzo

  attr_accessor :line, :vars

  def self.map(&block)

    b = Benzo.new(&block)
    b.to_line
  end

  def initialize(&block)
    @line = []
    @vars = {}

    block.call(self)
  end

  def option(name=nil, arg)
    arg.each do |k,v|
      @line << k if v

      if v && ! name.nil?
        @vars[name] = v
      end
    end
  end

  def to_line
    ::Cocaine::CommandLine.new('pg_dump', @line.join(' '), @vars)
  end

  def self.build(key,value)
    if value === true
      key
    else
      key
    end
  end

end
