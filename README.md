# xmonit/drupal8-apache

This is a flexible way to allow drupal to send emails, run behind load balancer or nginx reverse proxy, and use composer.  

See docker-compose.yml for an example... it requires setting up the /etc/ssmtp config files (ssmtp.conf and revaliases)

See https://www.nixtutor.com/linux/send-mail-with-gmail-and-ssmtp for an example using gmail

Set environment ENABLE_RPAF_MODULE to true if you want the rpaf module to automatically update REMOTE_ADDR, REMOTE_SCHEME, etc... using the reverse proxy headers from an external server.  See docker-compose for example.

