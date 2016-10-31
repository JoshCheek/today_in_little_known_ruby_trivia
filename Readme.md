Today in little known Ruby trivia
=================================

These were surely inspired by sferik's Ruby Trivia:

* [Ruby Trivia 1](https://speakerdeck.com/sferik/ruby-trivia)
* [Ruby Trivia 2](https://speakerdeck.com/sferik/ruby-trivia-2)
* Still happy to [collaborate](https://twitter.com/sferik/status/662677213758824448) ^^

October 31
----------

There are 9 types of arguments.
([link](https://twitter.com/josh_cheek/status/793060811237367809))

```ruby
shadow = :outside
lambda { |
  ord1,          # ordinal (required) before restargs
  opt=:opt,      # optional ordinal (defaults if not set)
  *rest,         # rest args (aggregates ordinals into an array)
  ord2,          # ordinal after restargs
  kw:,           # keyword, required
  kwopt: :kwopt, # optional keyword (defaults if not set)
  **kwrest,      # keyword rest args (aggregates keywords into a hash)
  &block;        # wraps block in a proc and assigns to a varaible
  shadow         # declares a new variable, ignoring the outside one
| ord1           # => :ord1
  opt            # => :opt
  rest           # => []
  ord2           # => :ord2
  kw             # => :kw
  kwopt          # => :kwopt
  kwrest         # => {}
  block.call     # => :block
  shadow         # => nil
}.call(:ord1, :ord2, kw: :kw) { :block }
```



October 30
----------

Global variables can be aliased.
([link](https://twitter.com/josh_cheek/status/792642615967617025))

```ruby
alias $a $b

$b = 1
$a # => 1

$a = 2
$b # => 2
```


October 29
----------

You don't need curly braces when interpolating
class variables, instance variables, or global variables
([link](https://twitter.com/josh_cheek/status/792454912386871297))

```ruby
a   = 1                # => 1
@@b = 2                # => 2
@c  = 3                # => 3
$d  = 4                # => 4
"-#{a}-#@@b-#@c-#$d-"  # => "-1-2-3-4-"
```


October 28
----------

Asperands are used to differentiate operators that go in the front vs the back
([link](https://twitter.com/josh_cheek/status/792028384393961473))

```ruby
class Symbol
  def -@(*) :front end
  def -(*)  :back  end
end

-:s      # => :front
:s - :t  # => :back

:s.-@    # => :front
:s.-     # => :back
```



October 27
----------

You can place ordinal-parameters before and after rest-parameters.
([link](https://twitter.com/josh_cheek/status/791790634151489536))

```ruby
def m(param1, *rest, param2)
  param1 # => 1
  rest   # => [2, 3, 4]
  param2 # => 5
end

m(1, 2, 3, 4, 5)
```


October 26
----------

Local variables are known before they are used.
([link](https://twitter.com/josh_cheek/status/791361239666397184))

```ruby
a = 1                # => 1
local_variables      # => [:a, :b]

eval('a')            # => 1
eval('b')            # => nil
eval('c') rescue $!  # => #<NameError: undefined local variable or method `c' for main:Object>
b = 2                # => 2
```


October 23
----------

Main's visibility starts off private, and methods defined there get added to Object.
([link](https://twitter.com/josh_cheek/status/790091502097604608))

```ruby
def x() 1 end
public
def y() 2 end

"abc".x rescue $!.message  # => "private method `x' called for \"abc\":String"
"abc".y                    # => 2
"abc".method(:x).owner     # => Object
```


October 22
----------

Main is just an object with some methods defined on its singleton class.
Explanation [here](global_functions.md).
([link](https://twitter.com/josh_cheek/status/789844581344960512))

```ruby
self # => main

class << self
  remove_method :inspect
end

self       # => #<Object:0x007fa3810d6660>
Object.new # => #<Object:0x007fa3818891c8>
```


October 20
----------

Global functions are private instance methods inherited from Kernel. Explanation [here](global_functions.md).
([link](https://twitter.com/josh_cheek/status/789230643087572994))

```ruby
# `puts` is a private method inherited from Kernel
self.method(:puts).owner # => Kernel
self.puts("a") rescue $! # => #<NoMethodError: private method `puts' called for main:Object\nDid you mean?  putc>
Kernel.module_eval { public :puts }
self.puts("b")

# Now it's public everywhere!
12345.puts("c")
"abc".puts("d")
Array.puts("e").puts("f")

# >> b
# >> c
# >> d
# >> e
# >> f
```


October 19
----------

There are 6 ways to call a proc.
Explanation [here](6_ways_to_call_a_proc.md).
([link](https://twitter.com/josh_cheek/status/788801646553886720))


```ruby
prc = lambda { |n| n + 1 }

prc.call 2    # => 3
prc === 2     # => 3
prc.yield 2   # => 3
prc[2]        # => 3
prc.(2)       # => 3
prc::(2)      # => 3
```


October 18
----------

The "scope resolution operator" looks up methods as well as constants. ([link](https://twitter.com/josh_cheek/status/788356344000737280))

```ruby
Array::                   # => Array
  new(5) { |n| n * 2 }::  # => [0, 2, 4, 6, 8]
  reduce(0, :+)::         # => 20
  even?                   # => true

Array::new(5) { |n| n * 2 }::reduce(0, :+)::even?  # => true
```


October 17
----------

Core constants are accessed via inheritance, not lexical scope. ([link](https://twitter.com/josh_cheek/status/787905568841142272))

```ruby
class String
  Array       # => Array
end           # => Array

class BasicObject
  Array # ~> NameError: uninitialized constant BasicObject::Array\nDid you mean?  Array
end
```


October 16
----------

`NameError::message` hangs onto the receiver so it can calculate the message on demand. ([link](https://twitter.com/josh_cheek/status/787709475377602560))

```ruby
s = String.new
e = s.m rescue $!

def s.inspect() "s1" end
e.message  # => "undefined method `m' for s1:String"

def s.inspect() "s2" end
e.message  # => "undefined method `m' for s2:String"
```


October 15
----------

Constants you're not supposed to know about. ([link](https://twitter.com/josh_cheek/status/787477591930376192))

```ruby
ObjectSpace.each_object(Module).select { |c| c.to_s[/(^|:)[a-z]/] }
# => [Complex::compatible,
#     Rational::compatible,
#     NameError::message,
#     fatal,
#     IO::generic_writable,
#     IO::generic_readable]
```


October 14
----------

Shadow variables ([link](https://twitter.com/josh_cheek/status/786915998343503872))

```ruby
a = 1  # => 1

lambda { |;a| a = 2 }.call  # => 2
a                           # => 1

lambda { a = 2 }.call  # => 2
a                      # => 2
```
