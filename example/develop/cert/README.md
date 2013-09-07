```bash

openssl genrsa -out develop-key.pem 1024
openssl req -new -key develop-key.pem -out develop-csr.pem
openssl x509 -req -in develop-csr.pem -signkey develop-key.pem -out develop-cert.pem

```
