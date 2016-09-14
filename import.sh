bin/rake db:drop
sudo -u postgres psql -c "alter role ubuntu superuser;"
sudo -u postgres createuser ktom
sudo -u postgres createdb -O ktom kontes_terbuka

cd import
cat * | psql --set ON_ERROR_STOP=on -1 kontes_terbuka
