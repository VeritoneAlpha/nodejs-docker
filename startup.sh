#!/bin/bash
# This is the base process of the container.

su node -c "cd /home/node/app && nohup npm start &> /home/node/app/nohup.out&"
tail -100f /home/node/app/nohup.out
