# Sourced by ~/.zshrc after CONF, PLATFORM, and path_to_zshrc are set.
# Sources configs from most general to most specific.

# things that should run at the very beginning
[[ -f $CONF/hosts/local/$path_to_zshrc.pre ]] && source $CONF/hosts/local/$path_to_zshrc.pre

# generally go from more general to more specific
# so we can override things as we go
source $CONF/common/$path_to_zshrc
[[ -f $CONF/platforms/$PLATFORM/$path_to_zshrc ]] && source $CONF/platforms/$PLATFORM/$path_to_zshrc
[[ -f $CONF/hosts/local/$path_to_zshrc ]] && source $CONF/hosts/local/$path_to_zshrc

# things that should run at the very end
[[ -f $CONF/common/$path_to_zshrc.end ]] && source $CONF/common/$path_to_zshrc.end
