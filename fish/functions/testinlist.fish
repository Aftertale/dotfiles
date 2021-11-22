function testinlist
  if contains $argv[1] $argv[2..-1]
    echo "is there"
  else
    echo "is not there"
  end
end
