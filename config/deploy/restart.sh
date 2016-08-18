nginx -s reopen
rm /var/run/unicorn.pid
service unicorn restart
