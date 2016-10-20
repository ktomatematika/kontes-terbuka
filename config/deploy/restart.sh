nginx -s reopen
kill `cat /var/run/unicorn.pid`
service unicorn restart

cd ~/kontes-terbuka/current/
PATH=/usr/local/texlive/2016/bin/x86_64-linux:$PATH bin/delayed_job restart
