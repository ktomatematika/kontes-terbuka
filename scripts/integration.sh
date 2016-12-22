export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start
sleep 3 # give xvfb time to start
rackup # start web server
sleep 3 # give web server time to setup
