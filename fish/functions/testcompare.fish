function testcompare
  if test "$AWS_PROFILE" = "$argv"
    echo Success
  else
    echo Failure
  end
end
