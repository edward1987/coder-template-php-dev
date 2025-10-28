#!/bin/bash
echo "[DEBUG] Waiting for attach..." && sleep 5
sudo mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "[INFO] Adjusting permissions..."
sudo chown -R $USER:$USER "$WORKDIR"
sudo chown -R $USER:$USER /home/$USER
sudo update-alternatives --set php /usr/bin/php8.3

# Change UID if specified
if [ ! -z "$WWWUSER" ]; then
    sudo usermod -u $WWWUSER $USER
fi
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"
# Download and install Node.js:
nvm install 22




  
# Laravel setup


# Start code-server
echo "[INFO] Installing and starting code-server..."
curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server
/tmp/code-server/bin/code-server --auth none --port 13337 --disable-telemetry > /tmp/code-server.log 2>&1 &

# Start Supervisor (Apache)
echo "[INFO] Starting supervisord..."
exec sudo /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf > /tmp/supervisor.log 2>&1 &
