nginx -s reopen
kill `cat /var/run/unicorn.pid`
service unicorn restart
