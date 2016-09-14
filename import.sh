bin/rake db:drop db:create
cd import
cat * | sudo -u postgres psql --set ON_ERROR_STOP=on -1 kontes_terbuka
