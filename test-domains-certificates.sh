#!/usr/bin/env bash
echo "###################################[$(date)]"
domains=( \
  "dev-provider.cloud.vmware.com"\
)
prefixes=( \
  "v1" \
  "api/v1" \
)

protocols=( \
  "https" \
)

methods=( \
  "GET" \
  "OPTIONS" \
)

for domain in "${domains[@]}"; do
  echo "#################################################################[START-$(date)] $domain "
  cat /dev/null > "./$domain.certificates.log"
  openssl s_client -connect "$domain":443 -prexit -showcerts &>"./$domain.certificates.log" && echo "Certificates: OK" || echo "Certificates: ERROR"

  cat /dev/null > "./$domain.request.log"

  for prefix in "${prefixes[@]}"; do
    for protocol in "${protocols[@]}"; do
      for method in "${methods[@]}"; do
        url="$protocol://$domain/$prefix/content/landing_page_v2?locale=en-us"
        echo "$url" >> "./$domain.request.log"
        curl -iv -L -X "$method" "$url" -H 'api-key: jzK%7@*zQBCJ9@5%' &>> "./$domain.request.log"
        response=$(curl -iv -L -X "$method" "$url" -H 'api-key: jzK%7@*zQBCJ9@5%' 2>&1 | grep "^HTTP\|^curl")
        echo "$method $url $response"
      done
    done
  done
  echo "#################################################################[END-$(date)] $domain "
done
