# things that should run at the very beginning
source $CONF/hosts/$HOST/$path_to_zshrc.pre

# generally go from more general to more specific
# so we can override things as we go
source $CONF/common/$path_to_zshrc
source $CONF/platforms/$PLATFORM/$path_to_zshrc
source $CONF/hosts/$HOST/$path_to_zshrc

# things that should run at the very end
source $CONF/common/$path_to_zshrc.end
