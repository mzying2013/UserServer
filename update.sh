git pull;
vapor build;
pid=$(lsof -i tcp:8069 |  sed -n "2,2p" | awk '{print $2}');
kill -9 $pid;
nohup .build/debug/Run --hostname 127.0.0.1 --port 8069 &