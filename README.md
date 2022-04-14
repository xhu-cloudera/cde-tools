# Automate CDE Tests Using Postman

## Postman setup

1. import environment: `ComputePlatform`
2. import collections: `DEX-INIT`, `DEX-BASE`, `DEX-Sanity Check`, `DEX-Sanity Check-Clean up`
3. set Postman `working directory` to the root folder of this repo.

`Preferences`--->`Settings`--->`General`--->`Working Directory`


## Update Environment to target cluster

1. update `dex-domain`
2. update `cdp-namespace`
3. update `cdp-cookie`

This is an example `curl` request:
```
curl 'https://console-cdp.apps.ecs-xhu-1.vpc.cloudera.com/dex/api/v1/cluster/cluster-mvgd7pwb/instance' \
  -H 'authority: console-cdp.apps.ecs-xhu-1.vpc.cloudera.com' \
  -H 'sec-ch-ua: "Google Chrome";v="95", "Chromium";v="95", ";Not A Brand";v="99"' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36' \
  -H 'ngsw-bypass: ' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://console-cdp.apps.ecs-xhu-1.vpc.cloudera.com/dex/overview/list-cluster/cluster-mvgd7pwb' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: cdp-pvt-session-token=eyJraWQiOm51bGwsImFsZyI6IkVTMjU2In0.eyJpc3MiOiJBbHR1cyBJQU0iLCJhdWQiOiJBbHR1cyBJQU0iLCJqdGkiOiJvR1MtYmVvWlZmNTB3V2JLOWROcnd3IiwiaWF0IjoxNjM2NTE3MjU4LCJleHAiOjE2MzY1NjA0NTgsInN1YiI6ImNybjphbHR1czppYW06dXMtd2VzdC0xOjQ4NmQ3ZTc3LWIxY2ItNGM3OS04ZjQ1LTg2MDkxZWRjNGUzNDp1c2VyOjBjYjlmYTVlLWU1NTktNDQ3ZS1hMTAxLTY3ZWRmNTk3M2YyMyJ9.JFUpc9_TEw21UE1yIiX4t43qtT1tKh0DaIWmNmO8d5Tk4VRCsOPb1hGZpC-z2CryuaOEIdR2sc-C3Bd1vecDXw; _ga=GA1.2.1507460914.1636517262; _gid=GA1.2.1795921332.1636517262; _gat=1; mdLogger=false; kampyle_userid=5249-e19a-c3dc-9294-c3e3-f4ce-8e21-a433; kampyleUserSession=1636517266950; kampyleUserSessionsCount=1; kampyleSessionPageCounter=1' \
  --compressed \
  --insecure
```

## Set `dex-base-host` and `dex-app-host`

Run `DEX-INIT` collections

## Submit Sanity check tests

1. send `GET` Token request under `DEX-BASE`
2. run `DEX-Sanity Check`
