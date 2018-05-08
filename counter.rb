pos, n = DATA.pos, DATA.read.to_i.succ
File.truncate __FILE__, pos
File.open(__FILE__, mode: 'a') { |f| f.puts n }
puts n
__END__
