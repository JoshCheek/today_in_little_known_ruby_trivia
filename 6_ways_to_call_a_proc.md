There are 6 ways to call a proc
===============================

If anyone knows more, let me know :)

Given this code:
----------------

```ruby
prc = lambda { |n| n + 1 }
```

1. `prc.call(2)  # => 3`
------------------------

This is the obvious way.


2. `prc === 2  # => 3`
----------------------

This lets you place a proc into a case statement

```ruby
case l = n = fork ? 1 : 2  # => 1, 2
when :odd?.to_proc
  "Odd ba#{l}#{l}"         # => "Odd ba11"
when :even?.to_proc
  "Eve#{n} steve#{n}"      # => "Eve2 steve2"
end                        # => "Odd ba11", "Eve2 steve2"
```


3. `prc.yield(2)  # => 3`
-------------------------

[Long ago](https://github.com/ruby/ruby/blob/9b383bd/eval.c#L8356-L8415), `.yield` would call it like a block and `.call` would call it like a lambda (same behaviour as a method).
Now, its block/lambdaness is an attribute.
Another interesting fact is that `proc` used to be an alias for `lambda`,
which is why I've historically advocated avoiding it and only using `Proc.new` and `lambda`.


4. ` prc[2]  # => 3`
--------------------

Brackets are syntactically similarity to parentheses, I'm pretty sure that was the motive behind their introduction.


5. ` prc.(2)  # => 3`
---------------------

`.()` is the new way to be syntactically similar to parentheses, it is syntactic sugar for `.call`
This was introduced in 1.9, I think.

You need the dot because `prc(3)` would look for a method named `prc`
rather than a local variable. I think they could just apply the same rules here as they do for resolving
a symbol that doesn't have arguments (you know, the one that says "undefined local variable or method" when you misspell it).
I'm guessing they didn't want to do that b/c they didn't want to break the programs that rely on the syntactic distinction
to differentiate between a local var and a method of the same name, eg `a = a()`, which sets a local to the value of the method.
Also, you'd then have to differentiate by doing `a = self.a`, but that won't work with private methods unless they add
another exception to the rules, and that would probably be confusing, complicated, and flaky.


6. `prc::(2)  # => 3`
---------------------

`::()` is the same as the one above. `::` is the "scope resolution operator" and it invokes a method when it can't find
a constant of that name. So it stands to reason that you can use it in place of the dot here, as well. Interestingly, despite working here, it doesn't work with the "safe navigation operator".

```ruby
Proc::new { |n| n + 3 }::(2)::*(5)  # => 25

-> one_two {
  one_two::(-> one { -> two { one } }) # => 1
  one_two::(-> one { -> two { two } }) # => 2
}::(-> lhs { -> rhs { -> fn { fn::(lhs)::(rhs) } } }::(1)::(2))
```
