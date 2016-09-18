bin/rake db:drop db:create
sudo -u postgres createuser ktom

cd import
cat * | sudo -u postgres psql --set ON_ERROR_STOP=on -1 kontes_terbuka

sudo -u postgres psql -d kontes_terbuka -c "REASSIGN OWNED BY ktom TO ubuntu;"
