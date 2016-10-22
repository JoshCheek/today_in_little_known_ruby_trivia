Main is just an object
======================

Main is just an object with some methods defined on its singleton class.

```ruby
class << self
  # these ones make it inspect fancily
  instance_methods false
  # => [:inspect, :to_s]

  # these ones let you do stuff that you normally can only do in a class
  private_instance_methods false
  # => [:include, :using, :public, :private, :define_method]
end
```

If we remove the `inspect` method from its singleton class,
it will find the `inspect` method from Kernel, instead.

```ruby
self # => main

class << self
  remove_method :inspect
end

self       # => #<Object:0x007fa3810d6660>
Object.new # => #<Object:0x007fa3818891c8>
```
