Global Functions
================

Global functions are private methods defined in the module `Kernel`,
which was included into Object.

```ruby
public :puts    # <-- hmm, isn't that strange? Maybe I'll make a separate one about how it works :P

puts "a"        # <-- looks like magic
puts("b")       # <-- but it's just a function
self.puts("c")  # <-- which is really a method on self

# >> a
# >> b
# >> c
```


They are "global" (available everywhere -- almost) because they were
included into Object, which everything except `BasicObject` inherits from.

```ruby
method(:puts).owner                                # => Kernel
123.method(:puts).owner                            # => Kernel
"abc".method(:puts).owner                          # => Kernel
Object.new.instance_eval { puts "from obj" }       # => nil
BasicObject.new.instance_eval { puts "no dice!" }  # ~> NoMethodError: undefined method `puts' for #<BasicObject:0x007fcdb20589f8>

# >> from obj
```

They are not visible as methods to other objects because they are private.

```ruby
123.methods.include? :puts          # => false
123.private_methods.include? :puts  # => true
```

If we make them public, then we can call them from outside the object.

```ruby
public :puts

self.puts("a")
123.puts("b")
"abc".puts("c")
Array.puts("d").puts("e")

# >> a
# >> b
# >> c
# >> d
# >> e
```
