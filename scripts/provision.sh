export DEBIAN_FRONTEND=noninteractive
#echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Install many stuff.
apt-get update
apt-get install --yes software-properties-common python-software-properties git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libgdbm-dev libncurses5-dev automake libtool bison virtualbox-guest-utils

# Installs and setups PostgreSQL
apt-get install --yes postgresql-9.5 libpq-dev
sudo -u postgres psql -c "create role ubuntu with createdb login password 'password';"

# Auto CD to /vagrant and squelch perl warnings
printf "\n\ncd /vagrant\nexport LC_ALL=en_US.UTF-8" >> /home/ubuntu/.bashrc

# Installs rvm, Ruby, Bundler and runs bundle install, which installs a lot.
su ubuntu <<'EOF'
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.5.0
rvm use 2.5.0 --default
gem install bundler
cd /vagrant
cp config/database.yml.default config/database.yml
bundle install
rvm rvmrc warning ignore allGemfiles
cp /vagrant/config/database.yml.default /vagrant/config/database.yml
bin/rake db:create
sudo -u postgres psql -d kontes_terbuka < /vagrant/db/structure.sql
sudo -u postgres psql -d kontes_terbuka -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ubuntu;'
EOF
