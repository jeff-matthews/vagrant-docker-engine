#!/bin/sh
set -e

# Save IP to a hostname
echo "192.168.56.10 docker.local" | sudo tee -a /etc/hosts > /dev/null

# Tell Docker CLI to talk to the VM (guest port)
export DOCKER_HOST=tcp://docker.local:80

# Optionally add it to your shell so don't need to repeat everytime
# echo "export DOCKER_HOST=http://docker.local:2375" | tee -a ~/.zshrc > /dev/null

# Test
docker run hello-world

# Errors

# ```
# error getting credentials - err: exec: "docker-credential-desktop": executable file not found in $PATH, out:
# ```

# https://github.com/docker/for-mac/issues/3785#issuecomment-619291706

# Removed ~/.docker/config.json and it started working

#```
# Error response from daemon: failed to create shim: OCI runtime create failed: container_linux.go:380: starting container process caused: process_linux.go:545: container init caused: rootfs_linux.go:75: mounting "/Users/jmatthew/git/experience-league/website/nginx.conf" to rootfs at "/etc/nginx/nginx.conf" caused: mount through procfd: not a directory: unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified host path exists and is the expected type
#```

# Changing the file name was the only thing that made it work.

# https://stackoverflow.com/questions/67591372/docker-are-you-trying-to-mount-a-directory-onto-a-file-or-vice-versa

