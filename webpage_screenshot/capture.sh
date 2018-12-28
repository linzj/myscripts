google-chrome --headless --hide-scrollbars --remote-debugging-port=9222 --disable-gpu &
npm install chrome-remote-interface minimist
nodejs capture.js --url="$1" --full
kill %1
