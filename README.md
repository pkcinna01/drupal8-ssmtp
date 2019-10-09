# xmonit/arm32v7-drupal8-apache

Raspberry PI4 compatible docker image for running drupal behind a load balancer or nginx reverse proxy.  

See docker-compose.yml for an example... it requires setting up the msmtp config files (see mounts folder for example) and also adding a settings.php with db credentials and allowed hosts.

Set environment ENABLE_RPAF_MODULE to true if you want the rpaf module to automatically update REMOTE_ADDR, REMOTE_SCHEME, etc... using the reverse proxy headers from an external server.  See docker-compose for example.
