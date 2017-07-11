#!/usr/bin/env bash
echo "###################################[$(date)]"
domain="dev-provider.cloud.vmware.com"

cat /dev/null > "./$domain.request.log"
cat /dev/null > "./$domain.certificates.log"

echo "#################################################################[START-$(date)] $domain "

certificatesLog="./$domain.certificates.log"

openssl s_client -connect "$domain":443 -prexit -showcerts &> "$certificatesLog" && \
  echo "Certificates: OK" || \
  echo "Certificates: ERROR"

requestLog="./$domain.request.log"

curl -si 'https://dev-provider.cloud.vmware.com/v1/content/landing_page_v2?locale=en-us' -X GET \
  -H 'origin: https://d3r56vi9y244ae.cloudfront.net' -H 'accept-encoding: gzip, deflate, br' \
  -H 'accept-language: pt-BR,pt;q=0.8,en-US;q=0.6,en;q=0.4' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36' \
  -H 'accept: application/json, text/plain, */*' -H 'referer: https://d3r56vi9y244ae.cloudfront.net/' \
  -H 'authority: dev-provider.cloud.vmware.com' -H 'api-key: jzK%7@*zQBCJ9@5%' --compressed | \
  tee -a "$requestLog" | grep "^HTTP\|^curl"

curl -si 'https://dev-provider.cloud.vmware.com/v1/content/landing_page_v2?locale=en-us' -X OPTIONS \
  -H 'pragma: no-cache' -H 'access-control-request-method: GET' -H 'origin: https://d3r56vi9y244ae.cloudfront.net' \
  -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: pt-BR,pt;q=0.8,en-US;q=0.6,en;q=0.4' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36' \
  -H 'accept: */*' -H 'cache-control: no-cache' -H 'authority: dev-provider.cloud.vmware.com' \
  -H 'referer: https://d3r56vi9y244ae.cloudfront.net/' -H 'access-control-request-headers: api-key' --compressed | \
  tee -a "$requestLog" | grep "^HTTP\|^curl"

echo "#################################################################[END-$(date)] $domain "
