Today in little known Ruby trivia
=================================

October 17
----------

Core constants are accessed via inheritance, not lexical scope. ((link)[https://twitter.com/josh_cheek/status/787905568841142272])

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

`NameError::message` hangs onto the receiver so it can calculate the message on demand. ((link)[https://twitter.com/josh_cheek/status/787709475377602560])

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

Constants you're not supposed to know about. ((link)[https://twitter.com/josh_cheek/status/787477591930376192])

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

Shadow variables ((link)[https://twitter.com/josh_cheek/status/786915998343503872])

```ruby
a = 1  # => 1

lambda { |;a| a = 2 }.call  # => 2
a                           # => 1

lambda { a = 2 }.call  # => 2
a                      # => 2
```
