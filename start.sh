#!/bin/bash
SVN_ROOT_PATH=/volume1/docker/subversion
REPO_PATH="$SVN_ROOT_PATH"/repos
BACKUP_PATH="$SVN_ROOT_PATH"/backup
DAV_SVN_CONF="$SVN_ROOT_PATH"/dav_svn

mkdir -p "$REPO_PATH" "$DAV_SVN_CONF"
if [ ! -f $DAV_SVN_CONF/dav_svn_authz ]; then
touch "$DAV_SVN_CONF"/dav_svn.authz "$DAV_SVN_CONF"/dav_svn.passwd
chmod 666 "$DAV_SVN_CONF"/dav_svn.authz "$DAV_SVN_CONF"/dav_svn.passwd
fi

docker run \
-d \
-v "$REPO_PATH":/var/local/svn \
-v "$BACKUP_PATH":/var/svn-backup \
-v "$DAV_SVN_CONF":/etc/apache2/dav_svn/ \
-p 9080:80 \
-p 9443:443 \
--name svnserver murks/debian-subversion \
--restart unless-stopped
