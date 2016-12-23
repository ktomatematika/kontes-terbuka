GECKODRIVER_VERSION=v0.11.1

export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start

wget https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz
tar -xf geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz
mv geckodriver /usr/local/bin
