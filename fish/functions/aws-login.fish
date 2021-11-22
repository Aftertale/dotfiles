function aws-login
  if test "$AWS_PROFILE" != "$argv" 
    aws-logout
  end
  aws --profile $argv sso login && export AWS_PROFILE="$argv"
end

function aws-logout
  aws sso logout
  set -e AWS_PROFILE
end
