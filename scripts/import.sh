#!bin/bash
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     machine=Linux;;
  Darwin*)    machine=Mac;;
  CYGWIN*)    machine=Cygwin;;
  MINGW*)     machine=MinGw;;
  *)          machine="UNKNOWN:${unameOut}"
esac
if [ "Mac" = "${machine}" ]; then
  bundle exec rake db:drop db:create
  createuser ktom

  cd import
  cat * | psql -d kontes_terbuka --set ON_ERROR_STOP=on -1

  psql -d kontes_terbuka -c "REASSIGN OWNED BY ktom TO ubuntu;"
elif [ "Linux" = "${machine}"]; then
  bin/rake db:drop db:create
  sudo -u postgres createuser ktom

  cd import
  cat * | sudo -u postgres psql --set ON_ERROR_STOP=on -1 kontes_terbuka

  sudo -u postgres psql -d kontes_terbuka -c "REASSIGN OWNED BY ktom TO ubuntu;"
fi
