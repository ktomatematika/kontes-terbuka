bin/rake db:drop db:create
sudo -u postgres psql -c "alter role ubuntu superuser;"

cd import
cat * | psql --set ON_ERROR_STOP=on -1 kontes_terbuka
