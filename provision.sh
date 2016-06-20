# Install many stuff.
apt-get update
apt-get install --yes --force-yes software-properties-common python-software-properties git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libgdbm-dev libncurses5-dev automake libtool bison

# Installs and setups PostgreSQL
sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt-get install --yes --force-yes postgresql-common
apt-get install --yes --force-yes postgresql-9.5 libpq-dev
sudo -u postgres psql -c "create role vagrant with createdb login password 'password';"

# Installs rvm, Ruby, Bundler and runs bundle install, which installs a lot.
su vagrant <<'EOF'
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.3.1
rvm use 2.3.1 --default
gem install bundler
cd /vagrant
bundle install
rvm rvmrc warning ignore allGemfiles
cp /vagrant/config/database.yml.default /vagrant/config/database.yml
bin/rake db:setup
EOF
