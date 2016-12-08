# for ls colors
export CLICOLOR=1

# these are Mac-specific pathnames
function load_nvm {
  export NVM_DIR="$HOME/.nvm"
  # manually interpolating brew prefix here to save 300ms
  #. "$(brew --prefix nvm)/nvm.sh"
  . /usr/local/opt/nvm/nvm.sh
  # AP 2016-06-24 - this slows the shell startup quite a bit,
  # consider something like autoenv
  nvm use default > /dev/null
}
alias nvm_load="load_nvm"
alias npm_load="load_nvm"
alias load_npm="load_nvm"
