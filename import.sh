bin/rake db:drop db:create
sudo -u postgres createuser ktom
sudo -u postgres createdb -O ktom kontes_terbuka

cd import
cat * | sudo -u postgres psql --set ON_ERROR_STOP=on -1 kontes_terbuka
