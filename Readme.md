Today in little known Ruby trivia
=================================

These were surely inspired by sferik's Ruby Trivia:

* [Ruby Trivia 1](https://speakerdeck.com/sferik/ruby-trivia)
* [Ruby Trivia 2](https://speakerdeck.com/sferik/ruby-trivia-2)
* Still happy to [collaborate](https://twitter.com/sferik/status/662677213758824448) ^^

October 19
----------

There are 6 ways to call a proc.
Explanation [here](6_ways_to_call_a_proc.md).

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
