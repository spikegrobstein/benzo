require 'rubygems'
require 'bundler/setup'

require 'awesome_print'

$: << File.dirname(__FILE__) + '/../lib'

require 'benzo'

def fixture_path(filename)
  File.join( File.dirname(__FILE__), 'fixtures', filename )
end
