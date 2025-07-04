# Open Source DDI Solution


```gql
mutation {
  CoreReadOnlyRepositoryCreate(
    data: {
      name: { value: "ddi" },
      location: { value: "https://github.com/marcom4rtinez/ddi.git" },
      ref: { value: "main" },
    }
  ) {
    ok
    object {
      id
    }
  }
}
```


## KEA 3 DB init script

```bash
mkdir -p initdb
wget "https://gitlab.isc.org/isc-projects/kea/raw/Kea-3.0.0/src/share/database/scripts/pgsql/dhcpdb_create.pgsql" -O ./initdb/dhcpdb_create.sql
```

## KEA RESTful API

Get configuration for DHCP4 service:
```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "config-get", "service": [ "dhcp4" ] }' http://localhost:8000/
```

Reload configuration for DHCP4 service:
```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "config-reload", "service": [ "dhcp4" ] }' http://localhost:8000/
```
```joson
[ { "arguments": { "hash": "D1496BAF7B75A037D9788178876193D6A6B9FE2B2CF2B6A27F9C701568354248" }, "result": 0, "text": "Configuration successful." } ]
```

Get command list before enabling hooks for DHCP4 service:
```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "list-commands", "service": [ "dhcp4" ] }' http://localhost:8000/
```
```json
[ { "arguments": [ "build-report", "config-backend-pull", "config-get", "config-hash-get", "config-reload", "config-set", "config-test", "config-write", "dhcp-disable", "dhcp-enable", "leases-reclaim", "list-commands", "server-tag-get", "shutdown", "statistic-get", "statistic-get-all", "statistic-remove", "statistic-remove-all", "statistic-reset", "statistic-reset-all", "statistic-sample-age-set", "statistic-sample-age-set-all", "statistic-sample-count-set", "statistic-sample-count-set-all", "status-get", "subnet4-select-test", "subnet4o6-select-test", "version-get" ], "result": 0 } ]
```

Get command list after enabling hooks for DHCP4 service:
```json
"hooks-libraries": [
    {
        "library": "/usr/lib/kea/hooks/libdhcp_host_cmds.so",
        "parameters": {}
    },
    {
        "library": "/usr/lib/kea/hooks/libdhcp_subnet_cmds.so",
        "parameters": {}
    }
]
```

```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "list-commands", "service": [ "dhcp4" ] }' http://localhost:8000/
```
```json
[ { "arguments": [ "build-report", "config-backend-pull", "config-get", "config-hash-get", "config-reload", "config-set", "config-test", "config-write", "dhcp-disable", "dhcp-enable", "leases-reclaim", "list-commands", "network4-add", "network4-del", "network4-get", "network4-list", "network4-subnet-add", "network4-subnet-del", "network6-add", "network6-del", "network6-get", "network6-list", "network6-subnet-add", "network6-subnet-del", "reservation-add", "reservation-del", "reservation-get", "reservation-get-all", "reservation-get-by-address", "reservation-get-by-hostname", "reservation-get-by-id", "reservation-get-page", "reservation-update", "server-tag-get", "shutdown", "statistic-get", "statistic-get-all", "statistic-remove", "statistic-remove-all", "statistic-reset", "statistic-reset-all", "statistic-sample-age-set", "statistic-sample-age-set-all", "statistic-sample-count-set", "statistic-sample-count-set-all", "status-get", "subnet4-add", "subnet4-del", "subnet4-delta-add", "subnet4-delta-del", "subnet4-get", "subnet4-list", "subnet4-select-test", "subnet4-update", "subnet4o6-select-test", "subnet6-add", "subnet6-del", "subnet6-delta-add", "subnet6-delta-del", "subnet6-get", "subnet6-list", "subnet6-update", "version-get" ], "result": 0 } ]
```




## Add new subnet

```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "subnet4-list", "service": [ "dhcp4" ] }' http://localhost:8000/
[ { "arguments": { "subnets": [  ] }, "result": 3, "text": "0 IPv4 subnets found" } ]
```

```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "subnet4-add", "service": [ "dhcp4" ], "arguments": {"subnet4": [{"id": 123,"subnet": "10.20.30.0/24"}]}}' h
ttp://localhost:8000/
[ { "arguments": { "subnets": [ { "id": 123, "subnet": "10.20.30.0/24" } ] }, "result": 0, "text": "IPv4 subnet added" } ]
```

```bash
curl -X POST -H "Content-Type: application/json" -d '{ "command": "subnet4-list", "service": [ "dhcp4" ] }' http://localhost:8000/
[ { "arguments": { "subnets": [ { "id": 123, "shared-network-name": null, "subnet": "10.20.30.0/24" } ] }, "result": 0, "text": "1 IPv4 subnet found" } ]
```


## Add new host reservation

```bash
curl -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "command": "reservation-add",
        "service": ["dhcp4"],
        "arguments": {
            "reservation": {
                "subnet-id": 123,
                "hw-address": "00:11:22:33:44:55"
            }
        }
    }' http://localhost:8000/
```

```json
[ { "arguments": { "subnets": [ { "id": 123, "subnet": "10.20.30.0/24" } ] }, "result": 0, "text": "IPv4 subnet added" } ]
```


