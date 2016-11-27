Today in little known Ruby trivia
=================================

These were surely inspired by sferik's Ruby Trivia:

* [Ruby Trivia 1](https://speakerdeck.com/sferik/ruby-trivia)
* [Ruby Trivia 2](https://speakerdeck.com/sferik/ruby-trivia-2)
* Still happy to [collaborate](https://twitter.com/sferik/status/662677213758824448) ^^


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


November 1
----------

You don't need brackets when assigning an array (there is an implicit array around multiple assignment).
([link](https://twitter.com/josh_cheek/status/793517994987098112))

```ruby
a = 1, 2, 3
a # => [1, 2, 3]
```


November 2
----------

Backticks are a method
([link](https://twitter.com/josh_cheek/status/793821846927998977))

```ruby
def `(str)
  str.reverse
end

`ls -l`  # => "l- sl"
```


November 3
----------

Every method can take a block.
Pretty sure it's stored [here](https://github.com/ruby/ruby/blob/trunk/vm_core.h#L636)
([link](https://twitter.com/josh_cheek/status/794181672526905346))

```ruby
# Some methods we call all the time
puts(1)    { 2 }  # => nil
Object.new { 3 }  # => #<Object:0x007fe2a2904098>
4.+(5)     { 6 }  # => 9

# Our own method
def omg() block_given? end  # => :omg
omg { 7 }                   # => true

def bbq() block_given? end  # => :bbq
bbq                         # => false

# >> 1
```


November 4
----------

Constant assignment is always based on lexical scope (the word "class" in the source code)
([link](https://twitter.com/josh_cheek/status/794585743259668483)).

```ruby
class A
end

class B
  ::A.module_eval   { C = :C }
  ::A.class_eval    { D = :D }
  ::A.instance_eval { E = :E }
  Class.new         { F = :F }
end

A.constants # => []
B.constants # => [:C, :D, :E, :F]
```


November 5
----------

Block scopes have a target class for the `def` keyword, the different types of eval modify this
([link](https://twitter.com/josh_cheek/status/794968385222217728)).

```ruby
C1 = Class.new  # => C1

class C2
  ::C1.module_eval   { def a() :a end } # C1
  ::C1.class_eval    { def b() :b end } # C1
  ::C1.instance_eval { def c() :c end } # C1's singleton class
  C3 = Class.new     { def d() :d end } # C2::C3
  lambda             { def e() :e end } # C2
end.call  # => :e

C1.new.a      # => :a
C1.new.b      # => :b
C1.c          # => :c
C2::C3.new.d  # => :d
C2.new.e      # => :e
```

The obvious thing to wonder, IMO, is what happens when you pass a method instead of a block.
As of 2.3.1, it does not change self (IIRC, it used to just explode in this situation).

```ruby
C1, C2 = Class.new, Class.new
def C1.omg(arg)
  self # => C1, C1, C1
  arg  # => C2, C2, C2
end
C2.module_eval   &C1.method(:omg)
C2.class_eval    &C1.method(:omg)
C2.instance_eval &C1.method(:omg)
```

And it does not change the deftarget (it's still Object).

```ruby
C, @count = Class.new, 0  # => [C, 0]

def self.omg(*)
  case @count += 1            # => 1, 2, 3, 4
  when 1 then def a() :a end  # => :a
  when 2 then def b() :b end  # => :b
  when 3 then def c() :c end  # => :c
  when 4 then def d() :d end  # => :d
  end                         # => :a, :b, :c, :d
end                           # => :omg

omg                            # => :a
C.module_eval   &method(:omg)  # => :b
C.class_eval    &method(:omg)  # => :c
C.instance_eval &method(:omg)  # => :d
Object.instance_methods false  # => [:b, :a, :d, :c]
```

November 6
----------

You can write code almost anywhere you like!
([link](https://twitter.com/josh_cheek/status/795280135163441152))

In this case, the namespace and superclass can be any code as long as it evaluates to a class.
The fork lets us see both branches of the if statement without changing code.

```ruby
class "In A #{class InANamespace; end} String!".class::AndAlso <
        if class InAConditional; end || fork # <-- lets us eval both branches of the if statement
          :"In A #{class AndInA; end} Symbol!".class
        else
          /In A #{class Superclass; end} Regex!/.class
        end
end
String::AndAlso.superclass # => Symbol, Regexp
```

November 7
----------

`not` is just syntactic sugar for `!@` ([link](https://twitter.com/josh_cheek/status/795778934965207040)).

```ruby
s = ""
def s.!@() "RAWR" end
!s     # => "RAWR"
not s  # => "RAWR"
```


November 9
----------

The `-e` flag lets you pass a program through ARGV instead of a filename containing a program
([link](https://twitter.com/josh_cheek/status/796497919474012160)).

```sh
$ ruby -e 'puts "hello, world"'
hello, world
```


November 10
-----------

The `-n` and `-p` flags iterate over every line of input, setting it to `$_`, `-p` prints `$_` out afterwards
([link](https://twitter.com/josh_cheek/status/796721958520033281)).

```sh
$ printf "abc\ndef\n" | ruby -n -e 'p $_'
"abc\n"
"def\n"

$ printf "abc\ndef\n" | ruby -p -e '$_ = $_.upcase'
ABC
DEF
```


November 11
-----------

When using `-n` or `-p`, the global variable `$.` contains the current input line number
([link](https://twitter.com/josh_cheek/status/797149586951405568)).

```sh
$ printf "abc\ndef\nghi\n"
abc
def
ghi

$ printf "abc\ndef\nghi\n" | ruby -p -e '$_ = "#{$.}\t#{$_}"'
1	abc
2	def
3	ghi
```

I suppose, to be fair, it's the current input line number regardless of whether you're using `-n` or `-p`,
that's the context you would use it in, but it doesn't depend on them.

```ruby
$stdin, $stdout = IO.pipe
puts "a\nb\nc"

$.   # => 0
gets # => "a\n"
$.   # => 1
gets # => "b\n"
$.   # => 2
```


November 12
-----------

The `-l` flag will automatically strip trailing newlines from input
([link](https://twitter.com/josh_cheek/status/797539812727201792)).

```sh
$ printf "abc\ndef\nghi\n" | ruby -ne 'puts "#{$_.inspect} #$_ #$."'
"abc\n" abc
 1
"def\n" def
 2
"ghi\n" ghi
 3

$ printf "abc\ndef\nghi\n" | ruby -l -ne 'puts "#{$_.inspect} #$_ #$."'
"abc" abc 1
"def" def 2
"ghi" ghi 3
```

Here is an example of where it is useful.

```sh
$ printf "abc\ndef\nghi\n" | ruby -lne 'puts "#$_ #$."'
abc 1
def 2
ghi 3

$ printf "abc\ndef\nghi\n" | ruby -ne 'puts "#$_ #$."'
abc
 1
def
 2
ghi
 3
```


November 13
-----------

The `-a` flag will split lines of input into an array stored in `$F`
([link](https://twitter.com/josh_cheek/status/797862561131724800)).

Here, we can see that `$F` is an array of the line being split (it is split by the input record separator, which is whitespace by default).

```sh
$ printf "a b c\nd e f\ng h i\n" | ruby -ane 'p $F'
["a", "b", "c"]
["d", "e", "f"]
["g", "h", "i"]

$ printf "a b c\nd e f\ng h i\n" | ruby -ane 'p $F'
["a", "b", "c"]
["d", "e", "f"]
["g", "h", "i"]
```

And here is an example of how we could use this to do arbitrarily convert input.
In this case, we're translating the output of `gem list` to list each gem and version on its own line
instead of aggregating all the versions behind the gems.

```sh
$ gem list | tail -4
webmock (2.1.0)
what_weve_got_here_is_an_error_to_communicate (0.0.8, 0.0.3)
xpath (2.0.0)
yard (0.9.5, 0.8.7.4)

$ gem list | ruby -ane '$F[1..-1].each { |ver| puts "#{$F[0]} #{ver.delete "(),"}" }' | tail -6
webmock 2.1.0
what_weve_got_here_is_an_error_to_communicate 0.0.8
what_weve_got_here_is_an_error_to_communicate 0.0.3
xpath 2.0.0
yard 0.9.5
yard 0.8.7.4
```


November 14
-----------

`print`, when invoked without arguments, prints the global variable `$_`
([link](https://twitter.com/josh_cheek/status/798261837271855106)).

```ruby
$_ = "a"
print
$_ = "b"
print

# >> ab
```

Here, we use it to filter the output of `gem list` to just show gems with 3 or more versions installed.

```sh
$ gem list | ruby -ane 'print if $F.length > 3'
minitest (5.9.1, 5.9.0, 5.8.4, 5.8.3, 5.7.0)
psych (2.1.1, default: 2.0.17)
rake (11.2.2, 11.1.2, 10.5.0, 10.4.2, 10.3.2)
rouge (1.11.1, 1.10.1, 1.9.0)
rspec-core (3.5.4, 3.5.3, 3.5.2, 3.5.1, 3.4.4, 3.2.3)
rspec-support (3.5.0, 3.4.1, 3.2.2)
seeing_is_believing (3.0.1, 3.0.0, 3.0.0.beta.7)
```

November 15
-----------

You can't guess what each line evaluates to!
([link](https://twitter.com/josh_cheek/status/798658276116176896))

Quiz:

```ruby
RUBY_VERSION        # => "2.3.1"
true if true        # =>
true if false       # =>
true if 0           # =>
true if nil         # =>
true if ""          # =>
true if :""         # =>
true if //          # =>
true if []          # =>
true if {}          # =>
true if 0...1       # =>
true if 1..2        # =>
if 1..2; true; end  # =>
if //; true; end    # =>
```

Answers:

```ruby
RUBY_VERSION        # => "2.3.1"
true if true        # => true
true if false       # => nil
true if 0           # => true
true if nil         # => nil
true if ""          # => true
true if :""         # => true
true if //          # => nil
true if []          # => true
true if {}          # => true
true if 0...1       # => true
true if 1..2        # => nil
if 1..2; true; end  # => true
if //; true; end    # => nil
```


November 16
-----------

A regex **literal** as the condition of an if statement is matched against `$_`
([link](https://twitter.com/josh_cheek/status/799010916088037376)).

```ruby
$_ = 'a'
true if /a/  # => true
true if /b/  # => nil
```

Eg you can use it to replace grep as in the examples below.
The nice thing about this is we get to use Ruby's regexes and can do a lot more than just filtering.

```ruby
$ printf "ab\nbc\nac\n" | ruby -ne 'print if /a/'
ab
ac

$ printf "ab\nbc\nac\n" | ruby -ne 'print if /b/'
ab
bc

$ printf "ab\nbc\nac\n" | ruby -ne 'print if /c/'
bc
ac
```


November 17
-----------

A numerical range **literal** as the condition of an if statement at the top-level (eg not in a method)
is a flip-flop that is matching against `$.`, the current line number. It becomes true when the first
number matches `$.` and false when the second number matches `$.`
([link](https://twitter.com/josh_cheek/status/799276498494648320)).

```ruby
$. = 2         # => 2
true if 1..10  # => nil
true if 2..10  # => true
true if 3..10  # => nil
```

Here we use it to filter lines of input based on their line number,
without this, we would have to learn sed or awk.

```sh
$ printf "FIRST\nSECOND\nTHIRD\nFOURTH\nFIFTH\n" | ruby -ne 'print if 2..4'
SECOND
THIRD
FOURTH
```

For comparison, the Ruby, sed, and awk implementations of the above:

```sh
$ printf "FIRST\nSECOND\nTHIRD\nFOURTH\nFIFTH\n" | ruby -ne 'print if 2..4'
$ printf "FIRST\nSECOND\nTHIRD\nFOURTH\nFIFTH\n" | sed -ne '2,4p'
$ printf "FIRST\nSECOND\nTHIRD\nFOURTH\nFIFTH\n" | awk '2 <= NR && NR<=4'
```


November 19
-----------

The -n and -p flags add private methods to main that implicitly operate on `$_`
([link](https://twitter.com/josh_cheek/status/799926885790715905)).


```
$ ruby -e 'p private_methods' | ruby -ne 'p private_methods - eval($_)'
[:chop, :sub, :gsub, :chomp]

$ printf "FIRST\nSECOND\nTHIRD\nFOURTH\nFIFTH\n" | ruby -pe 'gsub "I", "-"'
F-RST
SECOND
TH-RD
FOURTH
F-FTH
```

November 20
-----------

`-n` an `-p` will pull their input from filenames if they were provided
([link](https://twitter.com/josh_cheek/status/800459598469603328)).

```sh
# Create 3 files
$ printf "file-A line-1\nfile-A line-2\n" > fa
$ printf "file-B line-1\nfile-B line-2\n" > fb
$ printf "file-C line-1\nfile-C line-2\n" > fc

# Use them as input to the Ruby program
$ ruby -ne 'p line: $_' fa fb fc
{:line=>"file-A line-1\n"}
{:line=>"file-A line-2\n"}
{:line=>"file-B line-1\n"}
{:line=>"file-B line-2\n"}
{:line=>"file-C line-1\n"}
{:line=>"file-C line-2\n"}
```


November 21
-----------

`ARGF` is the object implementing `-n` and `-p`, it has useful info not contained in globals
([link](https://twitter.com/josh_cheek/status/800823280043180032)).

```sh
$ printf "file-A line-1\nfile-A line-2\n" > fa
$ printf "file-B line-1\nfile-B line-2\n" > fb
$ printf "file-C line-1\nfile-C line-2\n" > fc
$ ruby -ne 'p [$., ARGF.filename, ARGF.file.lineno, $_]' fa fb fc
[1, "fa", 1, "file-A line-1\n"]
[2, "fa", 2, "file-A line-2\n"]
[3, "fb", 1, "file-B line-1\n"]
[4, "fb", 2, "file-B line-2\n"]
[5, "fc", 1, "file-C line-1\n"]
[6, "fc", 2, "file-C line-2\n"]
```


November 23
-----------

`BEGIN` blocks run before anything else in your program, `END` blocks run after
([link](https://twitter.com/josh_cheek/status/801626228163747840)).

```ruby
BEGIN { p 1 }
END   { p 2 }
p 3
BEGIN { p 4 }
END   { p 5 }

# >> 1
# >> 4
# >> 3
# >> 5
# >> 2
```


November 24
-----------

`BEGIN` and `END` blocks run only once (they are intended to be used in -n/-p mode)
([link](https://twitter.com/josh_cheek/status/802015687493451776)).

```
$ printf "abc\ndef\nghi\n" | ruby -n -e '
     BEGIN { puts "Lines:" }
     print("  ", $_)
     END   { puts "Total:\n  #$." }
   '
Lines:
  abc
  def
  ghi
Total:
  3
```


November 25
-----------

`BEGIN` and `END` store local variables in their containing scope.
This lets them initialize variables for use in `-n` / `-p` mode
([link](https://twitter.com/josh_cheek/status/802291041806192640)).

```
$ printf "333\n55555\n22\n4444\n" | ruby -ln -e '
  BEGIN { longest = "" }
  longest = $_ if longest.length < $_.length
  END   { puts longest }
'
55555
```


November 26
-----------

Ruby's cryptic Perl variables have English names
([link](https://twitter.com/josh_cheek/status/802628880477650944)).

Here is a list: https://github.com/ruby/ruby/blob/4aefcbc5327be0f66ba8b1d9494c1573e52ab839/lib/English.rb#L23-L47


```sh
# In English
$ printf "ABC\nDEF\nGHI\n" | ruby -r english -ne 'puts "#$INPUT_LINE_NUMBER #$LAST_READ_LINE"'
1 ABC
2 DEF
3 GHI

# In Perl
$ printf "ABC\nDEF\nGHI\n" | ruby -r english -ne 'puts "#$. #$_"'
1 ABC
2 DEF
3 GHI
```


November 27
-----------

The opposite of a semicolon is a backslash, it lets you continue on the next line
([link](https://twitter.com/josh_cheek/status/802994776001966080)).

```ruby
# turned into 2 expressions
5     # => 5
 - 2  # => -2

# expression is continued on next line
5 \
 - 2  # => 3
```
