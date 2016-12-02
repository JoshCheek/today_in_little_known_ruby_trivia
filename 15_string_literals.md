There are 15 string literals
===========================

An example with all 15 in the same document is at the bottom.


Character literal
-----------------

```ruby
?c  # => "c"
```

It used to be that Ruby used numbers to represent characters, like in C.
In that case, it was convenient to have a literal that would let you type
the character and get the number back out (you can see these values
with `String#ord`).

When 1.9 rolled out, they switched to single character strings, so it
didn't make sense to have `?c` return the ordinal of the character `"c"`,
so they switched it over to just return the single character string.

This may have also reduced the backwards incompatibility, I'm not sure.

Easiest way to play around with this is on [eval.in](https://eval.in/689859)

```ruby
# Old ruby
p RUBY_VERSION   # 1.8.7

# Ask for the first char, it tells us the ascii value
string = "abc"
p string[0]      # 97

# Set a number into a string, it is interpreted as the ascii value
string[0] = 120  # x
p string         # xbc

# So ?y evaluates to ascii value of y.
# This lets us use the character instead of memorizing an ascii chart
string[0] = ?y   # 121
p string         # ybc
```



Double and single quotes
------------------------

```ruby
"double quotes"  # => "double quotes"
'single quotes'  # => "single quotes"
```

Double and single quoted strings are probably the most common.
They are the same except in how they handle special characters.

Double quotes let you put an escape character (backslash) before
another character, and it will be treated as "the other value"
of that character. So `"n"` is the character "n" (ascii 110),
but `"\n"` is the character "newline" (ascii 10).
Single quotes, however, turn off most of that stuff by default,
it's a much more literal interpretation of a string.

So, if you're entering lots of characters that don't have a visual representation,
like the escape character `"\e"`, you'll want double quotes.
But if you're entering lots of backslashes, you'll want single quotes.

Another place they're different is that double quotes allow interpolation
while single quotes do not. Note that you can escape the interpolation sequence
to turn that off in double quotes.

```ruby
a = 1     # => 1
"-#{a}-"  # => "-1-"
'-#{a}-'  # => "-\#{a}-"
```


Percent q and Percent Q
-----------------------

```ruby
%q(abc)  # => "abc"
%Q(abc)  # => "abc"
```

So if you've been [following](https://twitter.com/josh_cheek)
little known Ruby trivia, you know that Ruby has a ton of
Perl influences (eg all that command line stuff), and that's where
the percent notations come from. Perl has a `q` function and a `qq` function
which map to Ruby's `%q` and `%Q`.
[Here](https://perlmaven.com/quoted-interpolated-and-escaped-strings-in-perl)
is a blog that talks about them in Perl.

The interesting thing about these though, is that you can choose your delimiter.

```ruby
%q(abc)  # => "abc"
%q"abc"  # => "abc"
%q[abc]  # => "abc"
%q|abc|  # => "abc"
```

This is convenient if you have single and double quotes in your string,
you don't have to escape them.

```ruby
"She said \"that's mine!\""  # => "She said \"that's mine!\""
'She said "that\'s mine!"'   # => "She said \"that's mine!\""
%q(She said "That's mine!")  # => "She said \"That's mine!\""
```

`%q` behaves like single quotes and `%Q` behaves like double quotes.
Keeping in mind that this came from Perl, in Perl, `q` was a single quote
and `qq` was a double, the number of q's matched the number of quotes.
In ruby, they only support a single character, so instead of two q's,
they capitalized it. You can think of it like a capital "Q" being
more quoted than a lower-case "q", and double quotes are more quoted than single.

```ruby
a = 1
%q(-#{a}-)  # => "-\#{a}-"
%Q(-#{a}-)  # => "-1-"
```


Percent
-------

So there's now a lot of percent notations beyond just the Qs.
Presumably they said "there should be a default for when you don't
follow it with a character". Since `%Q` is the most likely one to be used,
it became the default. Note that this narrative is what I dreamed up,
I have no confirmation.

So, `%` becomes a synonym for `%Q`

```ruby
a = 1      # => 1
%(-#{a}-)  # => "-1-"
```

This is especially useful when you want to obfuscate some code since
`%` is a valid delimiter!

```ruby
%.abc.  # => "abc"
%%abc%  # => "abc"
%%%     # => ""
```

And it's also a synonym for sprintf, so you can do this:

```ruby
sprintf "a%s", "b"  # => "ab"
sprintf "a",   "b"  # => "a"
"a" % "b"           # => "a"
%%a% % %%b%         # => "a"
%%% % %%%           # => ""
%%%%%%%             # => ""
%%%%%%%%%%%         # => ""
```

Which lets you make fun tweets like [this](https://twitter.com/josh_cheek/status/658032347887996928)
one!

```ruby
puts %);%s#$/o%%sO)%%%)%%%^_^  # => nil

# >> ;)
# >> o_O
```


Heredocuments
-------------

Here documents allow you to place the body of the string after the current line.
It will consider everything after that line to be part of the body until it sees
the delimiter.

```ruby
"before " + <<HERE + " after"  # => "before within\n after"
within
HERE
```

These also come from Perl, and probaly came from the shell before that.
You can see they make a lot of sense in Bash, since Bash is line based and doesn't
handle multi-line inputs well, how do you provide a multi-line input? Heredocuments
provide a reasonable answer to this:

```sh
$ tr a e <<HERE | tr b w
> bat
> ball
> HERE
wet
well
```

You can imagine combining this with `xargs` in some particularly effective manner
that lets you construct a beautiful pipeline.

Ruby gives you 3 styles of indentation and 3 styles of quoting,
3 times 3 is 9, so there are **9 styles of here documents**.


The 3 styles of heredoc indentation
-----------------------------------

An unadorned heredocument is like the Bash example above, it will look for the
closing delimiter at the beginning of the line.

```ruby
<<HERE  # => "The \"HERE\" down below\ncannot be indented\n"
The "HERE" down below
cannot be indented
HERE
```

Notice that this is annoying when you're in an indented context, though.
For example, [here](https://github.com/rspec/rspec-core/blob/af3689b90909c64b567b7565649d2925701a64d0/lib/rspec/core/memoized_helpers.rb#L207-L215)
in RSpec, it throws the indentation off. That's why there is the dashed version
which lets you indent the final delimiter (in the link above, they use the dashed version,
but still don't indent the delimiter).

```ruby
def string
  <<-HERE
  The "HERE" down below can be indented
  because of the "-" after the "<<"
  HERE
end

string
# => "  The \"HERE\" down below can be indented\n" +
#    "  because of the \"-\" after the \"<<\"\n"
```

Better, but notice the output string has leading whitespace. We wanted to indent
the contents of the here document along with the delimiter, but that indentation
was preserved in the output string. This has led to things like ActiveSupport's
[`strip_heredoc`](https://github.com/rails/rails/blob/8ce903af862d56b77d60c3809c0442cdac9d6c89/activesupport/lib/active_support/core_ext/string/strip.rb)
method.

So, In 2.3.2, Ruby [added](https://github.com/ruby/ruby/blob/4a7c767ed2ab40c8bc56b9ff0c3d5bb8ee64ea3a/parse.y#L6411-L6416)
the third style of indentation, the `~`, which removes leading indentation
from the contents of the string, as well:

```ruby
def string
  <<~HERE
  The "HERE" down below can be indented
  because of the "~" after the "<<"
  HERE
end

string
# => "The \"HERE\" down below can be indented\n" +
#    "because of the \"~\" after the \"<<\"\n"
```


The 3 styles of heredoc quoting
-------------------------------

Ruby's heredocuments allow you to specify whether they should behave like
single or double quoted strings. You can do this by wrapping the delimiter
in single or double quotes. This is also useful if you want a delimiter
that contains otherwise invalid characters like spaces and dots
([eg](https://github.com/JoshCheek/seeing_is_believing/blob/master/seeing_is_believing.gemspec#L82)).

```ruby
<<HERE.upcase  # => "HERE DOC\n"
here doc
HERE

<<"HERE.upcase"  # => "here doc\n"
here doc
HERE.upcase
```

The three styles are unquoted, single quoted, and double quoted.
These match up with `%`, `%q`, and `%Q`.

Unquoted, like `%`, behaves as if double quoted,
a reasonable default for when you haven't specified.

```ruby
a = 1
<<HERE  # => "-1-\n"
-#{a}-
HERE
```

Single quoted, like `%q`, behaves as if single quoted.

```ruby
a = 1
<<'HERE'  # => "-\#{a}-\n"
-#{a}-
HERE
```

And double quoted, like `%Q`, behaves as if double quoted.

```ruby
a = 1
<<"HERE"  # => "-1-\n"
-#{a}-
HERE
```


All together
============

So, here are the 15 styles of string literals all together:

```ruby
# Character literal
?c  # => "c"

# Single and Double quotes
'single quotes'  # => "single quotes"
"double quotes"  # => "double quotes"

# Three Perl-style quotes
%(percent)     # => "percent"
%q(percent-q)  # => "percent-q"
%Q(percent-Q)  # => "percent-Q"

# 9 heredoc styles
<<HERE1    # => "unadorned, unquoted\n"
unadorned, unquoted
HERE1
<<'HERE2'  # => "unadorned, single quoted\n"
unadorned, single quoted
HERE2
<<"HERE3"  # => "unadorned, double quoted\n"
unadorned, double quoted
HERE3

<<-HERE1    # => "dashed, unquoted\n"
dashed, unquoted
HERE1
<<-'HERE2'  # => "dashed, single quoted\n"
dashed, single quoted
HERE2
<<-"HERE3"  # => "dashed, double quoted\n"
dashed, double quoted
HERE3

<<~HERE1    # => "squiggly, unquoted\n"
squiggly, unquoted
HERE1
<<~'HERE2'  # => "squiggly, single quoted\n"
squiggly, single quoted
HERE2
<<~"HERE3"  # => "squiggly, double quoted\n"
squiggly, double quoted
HERE3
```
