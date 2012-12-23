# Benzo  [![Build Status](https://travis-ci.org/spikegrobstein/benzo.png)](https://travis-ci.org/spikegrobstein/benzo)

*Take the edge off when doing (command) lines.*

**This is the unstable/2.0.0 branch. Docs may be incomplete or completely incorrect.
This is your warning.**

Wrapping [Cocaine](https://github.com/thoughtbot/cocaine), this library will
greatly simplify building complex and conditional commandline arguments.

This is especially useful when creating wrappers for other commandline tools.

## Installation

Add this line to your application's Gemfile:

    gem 'benzo', '~> 2.0.0'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install benzo

## Quickstart Example

Given that you want to make a call to `pg_dump`, but depending on some conditions
in your code, you may want to have certain arguments shown or not shown:

```ruby
# the state of our app:
@verbose = true
@database = 'app_production'
@file = 'app_prod-dump'

# build the Cocaine::Commandline with Benzo
Benzo.run!('pg_dump', {
  '-v' => @verbose,
  '--schema-only' => @schema_only, # note, @schema_only is nil
  '-f :filename' => @file,
  ':db_name' => @database
```

Benzo takes 2 arguments: `command` and `options_map`. The command is, like in
`cocaine`, the command you wish to run, and `options_map` is a hash containing
the data necessary to build the commandline arguments.

Any value in the hash that evaluates to `false` (this includes `nil`) will be
omitted from the command.

## A More Complex Example

```ruby
# the state of our app:
@verbose = true
@database = 'app_production'
@file = 'app_prod-dump'

# build a Benzo object:
b = Benzo.new('pg_dump',
  '-v' => @verbose,
  '--schema-only' => @schema_only, # note, @schema_only is nil
  '-f :filename' => @file,
  ':db_name' => @database
)

b.run # => runs the command: "pg_dump -v -f 'app_prod-dump' 'app_production'"

b.options_map['--schema-only'] = true

b.command # => pg_dump -v --schema-only -f 'app_prod-dump' 'app_production'

c = b.cocaine # => returns a Cocaine::CommandLine object

c.run(:db_name => 'other_db', :filename => 'other_db-dump') # => run it with different options
```

After creating a Benzo object, you can modify the `options_map` on the fly and
Benzo will re-map it when calling `#command` or `#run`. There is also a `#cocaine`
function that will return the `Cocaine::CommandLine` object.

## How options_map works

See **Limitations and Gotchas** section below if you're not using Benzo in Ruby 1.9.

`options_map` is a hash that gets processed by `Benzo` to create the
`Cocaine::CommandLine` object. The hash gets iterated over and any values that
evaluate to `false` are discarded, then the keys are concatinated together with
spaces to create the commandline arguments that are passed to `cocaine`. Any
symbols embedded in those strings will be used to build the variables to be
interpolated by `cocaine`.

Given the following `options_map`:

```ruby
{
  '-f :file' => "file.dat",
  "-v" => true,
  "-d" => false,
  ":data" => nil
}
```

The resulting command's arguments will be built as `-f 'file.dat' -v` omitting the
`-d` and `:data` values because the values of the hash evaluated to false.

When `Benzo` looks at the keys, it tries to find a symbol (a string leading with
a `:`). It will then use that as the key for whatever value it points to when
building the commandline. For example, `'-f :file' => 'file.dat'` will set `:file`
to `'file.dat'` when passing it to `cocaine`.

You can also pass a symbol as a key directly to the `options_map`, which will be
passed directly to `cocaine` when building the commandline. This is useful if you
want to use the `Logger` or `:expected_outcodes` facilities in `cocaine`. For
example (modified from one of the `cocaine` examples):

```ruby
line = Benzo.line('/usr/bin/false', {
  :expected_outcodes => [ 0, 1 ]
})

begin
  line.run
rescue Cocaine::ExitStatusError => e
  # => You never get here!
end
```

## Limitations and Gotchas

Because Benzo uses Hash keys to build the commandline string and that order may matter,
if you're not running Ruby 1.9, you should pass an [OrderedHash](https://rubygems.org/gems/orderedhash)
for the `options_hash`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgements

Benzo is written by Spike Grobstein, and wraps [Cocaine](https://github.com/thoughtbot/cocaine) by
[Thoughtbot](http://www.thoughtbot.com)

## Author

Spike Grobstein  
me@spike.cx  
http://spike.grobste.in  
https://github.com/spikegrobstein

