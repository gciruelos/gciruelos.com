# server set-up documentation

## server

ubuntu (ideally x64)

https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04

installed packages (apt list --manual-installed=true)


* **nginx:** https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04
* **fail2ban:** https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04
* **cgit:** https://wiki.archlinux.org/title/cgit#Using_fcgiwrap
* **cabal**


## directory structure

username is $USER

git repositories are found on ~ (/home/$USER).

* **/etc/nginx/...**: nginx config
* **/etc/cgitrc**: cgit config
* **/srv/git/...**: git repositories (links to other places)
  * user:$USER, group:git. chmod 755.
* **/var/www/gciruelos.com/...**: site


## users and groups

`less /etc/passwd`

* **$USER**: user
* **www-data**: owns /var/www and others.
* **dockeruser**: runs docker stuff.

`less /etc/group`
* **git**: members are $USER and www-data


## useful commands

### change chmod files and directories
find /path/to/dir -type d -exec chmod 755 {} \;
find /path/to/dir -type f -exec chmod 644 {} \;


### copy remote directory (direrctory name (dir) will be copied)
scp -P 1995 -r strangemeadowlark@104.131.180.124:/path/to/dir .
