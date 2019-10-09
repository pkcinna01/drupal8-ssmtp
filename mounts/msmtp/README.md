# see msmtp documentation

This folder requires a msmtprc file and an optional aliases file.

Example for a Zoho email account:

```defaults
auth           on
tls            on
aliases        /etc/msmtp/aliases

account        zoho
host           smtp.zoho.com
port           587
from           [zoho email]
user           [zoho email] 
password       [zoho password]

account default : zoho
```

