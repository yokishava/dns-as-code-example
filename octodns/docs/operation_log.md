
# Operation Log

※zoneの作成とIPの予約を事前に手動で行っている

https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address

Domain : `yokishava.dev`

## dump

### Run
```shell

% octodns-dump --config-file=./octodns/config/staging.yaml --output-dir=dump/ yokishava.dev. googlecloud
2022-11-30T20:55:09  [4567950848] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T20:55:09  [4567950848] INFO  Manager _config_executor: max_workers=1
2022-11-30T20:55:09  [4567950848] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T20:55:09  [4567950848] INFO  Manager __init__: global_processors=[]
2022-11-30T20:55:09  [4567950848] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T20:55:09  [4567950848] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T20:55:09  [4567950848] INFO  Manager dump: zone=yokishava.dev., output_dir=dump/, output_provider=None, lenient=False, split=False, sources=['googlecloud']
2022-11-30T20:55:09  [4567950848] INFO  Manager dump: using custom YamlProvider
2022-11-30T20:55:11  [4567950848] INFO  GoogleCloudProvider[googlecloud] populate: found 1 records, exists=True
2022-11-30T20:55:11  [4567950848] INFO  YamlProvider[dump] plan: desired=yokishava.dev.
2022-11-30T20:55:11  [4567950848] INFO  YamlProvider[dump] plan:   Creates=1, Updates=0, Deletes=0, Existing Records=0
2022-11-30T20:55:11  [4567950848] INFO  YamlProvider[dump] apply: making 1 changes to yokishava.dev.


```

### Result

```yaml

---
? ''
: ttl: 21600
  type: NS
  values:
  - ns-cloud-b1.googledomains.com.
  - ns-cloud-b2.googledomains.com.
  - ns-cloud-b3.googledomains.com.
  - ns-cloud-b4.googledomains.com.

```

## Dry Run

静的IPをあらかじめ `gcloud` によって予約

usecase: `www.yokishava.dev` のAレコード追加

### Input

`./octodns/config/yokishava.dev.yaml`

```yaml

---
? ''
: ttl: 21600
  type: NS
  values:
  - ns-cloud-b1.googledomains.com.
  - ns-cloud-b2.googledomains.com.
  - ns-cloud-b3.googledomains.com.
  - ns-cloud-b4.googledomains.com.

www:
  type: A
  values:
    - 34.117.199.108

```

## Validte

### input

```yaml
---
? ''
: ttl: 21600
  type: NS
  values:
  - ns-cloud-b1.googledomains.com.
  - ns-cloud-b2.googledomains.com.
  - ns-cloud-b3.googledomains.com.
    - ns-cloud-b4.googledomains.com.
```

### Run & Result

```
 % octodns-validate --config-file=./octodns/config/staging.yaml
Traceback (most recent call last):
  File "/Users/takahiroyoshikawa/miniconda3/bin/octodns-validate", line 8, in <module>
    sys.exit(main())
  File "/Users/takahiroyoshikawa/miniconda3/lib/python3.7/site-packages/octodns/cmds/validate.py", line 24, in main
    manager.validate_configs()
  File "/Users/takahiroyoshikawa/miniconda3/lib/python3.7/site-packages/octodns/manager.py", line 814, in validate_configs
    source.populate(zone, lenient=lenient)
  File "/Users/takahiroyoshikawa/miniconda3/lib/python3.7/site-packages/octodns/provider/yaml.py", line 217, in populate
    self._populate_from_file(filename, zone, lenient)
  File "/Users/takahiroyoshikawa/miniconda3/lib/python3.7/site-packages/octodns/provider/yaml.py", line 175, in _populate_from_file
    zone, name, d, source=self, lenient=lenient
  File "/Users/takahiroyoshikawa/miniconda3/lib/python3.7/site-packages/octodns/record/__init__.py", line 153, in new
    raise ValidationError(fqdn, reasons)
octodns.record.ValidationError: Invalid record yokishava.dev.
  - Invalid NS value "ns-cloud-b3.googledomains.com. - ns-cloud-b4.googledomains.com." is not a valid FQDN.

```

### Run　 & Result

```shell

% octodns-sync --config-file=./octodns/config/staging.yaml                                                         
2022-11-30T20:56:36  [4522292736] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T20:56:36  [4522292736] INFO  Manager _config_executor: max_workers=1
2022-11-30T20:56:36  [4522292736] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T20:56:36  [4522292736] INFO  Manager __init__: global_processors=[]
2022-11-30T20:56:36  [4522292736] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T20:56:36  [4522292736] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T20:56:36  [4522292736] INFO  Manager sync: eligible_zones=[], eligible_targets=[], dry_run=True, force=False, plan_output_fh=<stdout>
2022-11-30T20:56:36  [4522292736] INFO  Manager sync:   zone=yokishava.dev.
2022-11-30T20:56:36  [4522292736] INFO  Manager sync:   sources=['config'] -> targets=['googlecloud']
2022-11-30T20:56:36  [4522292736] INFO  YamlProvider[config] populate:   found 2 records, exists=False
2022-11-30T20:56:36  [4522292736] INFO  GoogleCloudProvider[googlecloud] plan: desired=yokishava.dev.
2022-11-30T20:56:38  [4522292736] INFO  GoogleCloudProvider[googlecloud] populate: found 1 records, exists=True
2022-11-30T20:56:38  [4522292736] INFO  GoogleCloudProvider[googlecloud] plan:   Creates=1, Updates=0, Deletes=0, Existing Records=1
2022-11-30T20:56:38  [4522292736] INFO  Plan 
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Create <ARecord A 3600, www.yokishava.dev., ['34.117.199.108']> (config)
*   Summary: Creates=1, Updates=0, Deletes=0, Existing Records=1
********************************************************************************



```

## Create

### Run

```shell

% octodns-sync --config-file=./octodns/config/staging.yaml --doit
2022-11-30T20:56:47  [4673218048] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T20:56:47  [4673218048] INFO  Manager _config_executor: max_workers=1
2022-11-30T20:56:47  [4673218048] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T20:56:47  [4673218048] INFO  Manager __init__: global_processors=[]
2022-11-30T20:56:47  [4673218048] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T20:56:47  [4673218048] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T20:56:47  [4673218048] INFO  Manager sync: eligible_zones=[], eligible_targets=[], dry_run=False, force=False, plan_output_fh=<stdout>
2022-11-30T20:56:47  [4673218048] INFO  Manager sync:   zone=yokishava.dev.
2022-11-30T20:56:47  [4673218048] INFO  Manager sync:   sources=['config'] -> targets=['googlecloud']
2022-11-30T20:56:47  [4673218048] INFO  YamlProvider[config] populate:   found 2 records, exists=False
2022-11-30T20:56:47  [4673218048] INFO  GoogleCloudProvider[googlecloud] plan: desired=yokishava.dev.
2022-11-30T20:56:49  [4673218048] INFO  GoogleCloudProvider[googlecloud] populate: found 1 records, exists=True
2022-11-30T20:56:49  [4673218048] INFO  GoogleCloudProvider[googlecloud] plan:   Creates=1, Updates=0, Deletes=0, Existing Records=1
2022-11-30T20:56:49  [4673218048] INFO  Plan 
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Create <ARecord A 3600, www.yokishava.dev., ['34.117.199.108']> (config)
*   Summary: Creates=1, Updates=0, Deletes=0, Existing Records=1
********************************************************************************


2022-11-30T20:56:49  [4673218048] INFO  GoogleCloudProvider[googlecloud] apply: making 1 changes to yokishava.dev.
2022-11-30T20:56:56  [4673218048] INFO  Manager sync:   1 total changes

```

### Result

```shell

% gcloud dns record-sets list --zone=yokishava-dev
NAME                TYPE  TTL    DATA
yokishava.dev.      NS    21600  ns-cloud-b1.googledomains.com.,ns-cloud-b2.googledomains.com.,ns-cloud-b3.googledomains.com.,ns-cloud-b4.googledomains.com.
yokishava.dev.      SOA   21600  ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300
www.yokishava.dev.  A     3600   34.117.199.108


% nslookup www.yokishava.dev
Server:		118.238.201.33
Address:	118.238.201.33#53

Non-authoritative answer:
Name:	www.yokishava.dev
Address: 34.117.199.108


```

## Change

既存のAレコードのサブドメインを変更

### input

```yaml
---
? ''
: ttl: 21600
  type: NS
  values:
  - ns-cloud-b1.googledomains.com.
  - ns-cloud-b2.googledomains.com.
  - ns-cloud-b3.googledomains.com.
  - ns-cloud-b4.googledomains.com.

app:
  type: A
  values:
    - 34.117.199.108
```

### Dry Run

```

% octodns-sync --config-file=./octodns/config/staging.yaml
2022-11-30T21:08:08  [4563023360] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T21:08:08  [4563023360] INFO  Manager _config_executor: max_workers=1
2022-11-30T21:08:08  [4563023360] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T21:08:08  [4563023360] INFO  Manager __init__: global_processors=[]
2022-11-30T21:08:08  [4563023360] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T21:08:08  [4563023360] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T21:08:08  [4563023360] INFO  Manager sync: eligible_zones=[], eligible_targets=[], dry_run=True, force=False, plan_output_fh=<stdout>
2022-11-30T21:08:08  [4563023360] INFO  Manager sync:   zone=yokishava.dev.
2022-11-30T21:08:08  [4563023360] INFO  Manager sync:   sources=['config'] -> targets=['googlecloud']
2022-11-30T21:08:08  [4563023360] INFO  YamlProvider[config] populate:   found 2 records, exists=False
2022-11-30T21:08:08  [4563023360] INFO  GoogleCloudProvider[googlecloud] plan: desired=yokishava.dev.
2022-11-30T21:08:10  [4563023360] INFO  GoogleCloudProvider[googlecloud] populate: found 2 records, exists=True
2022-11-30T21:08:10  [4563023360] INFO  GoogleCloudProvider[googlecloud] plan:   Creates=1, Updates=0, Deletes=1, Existing Records=2
2022-11-30T21:08:10  [4563023360] INFO  Plan 
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Delete <ARecord A 3600, www.yokishava.dev., ['34.117.199.108']>
*   Create <ARecord A 3600, app.yokishava.dev., ['34.117.199.108']> (config)
*   Summary: Creates=1, Updates=0, Deletes=1, Existing Records=2
********************************************************************************

```

[個人的メモ]
Updateはどういうとき？（IP変えたりしたら）

### Run

```
% octodns-sync --config-file=./octodns/config/staging.yaml --doit
2022-11-30T21:09:03  [4512167424] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T21:09:03  [4512167424] INFO  Manager _config_executor: max_workers=1
2022-11-30T21:09:03  [4512167424] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T21:09:03  [4512167424] INFO  Manager __init__: global_processors=[]
2022-11-30T21:09:03  [4512167424] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T21:09:03  [4512167424] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T21:09:03  [4512167424] INFO  Manager sync: eligible_zones=[], eligible_targets=[], dry_run=False, force=False, plan_output_fh=<stdout>
2022-11-30T21:09:03  [4512167424] INFO  Manager sync:   zone=yokishava.dev.
2022-11-30T21:09:03  [4512167424] INFO  Manager sync:   sources=['config'] -> targets=['googlecloud']
2022-11-30T21:09:03  [4512167424] INFO  YamlProvider[config] populate:   found 2 records, exists=False
2022-11-30T21:09:03  [4512167424] INFO  GoogleCloudProvider[googlecloud] plan: desired=yokishava.dev.
2022-11-30T21:09:05  [4512167424] INFO  GoogleCloudProvider[googlecloud] populate: found 2 records, exists=True
2022-11-30T21:09:05  [4512167424] INFO  GoogleCloudProvider[googlecloud] plan:   Creates=1, Updates=0, Deletes=1, Existing Records=2
2022-11-30T21:09:05  [4512167424] INFO  Plan 
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Delete <ARecord A 3600, www.yokishava.dev., ['34.117.199.108']>
*   Create <ARecord A 3600, app.yokishava.dev., ['34.117.199.108']> (config)
*   Summary: Creates=1, Updates=0, Deletes=1, Existing Records=2
********************************************************************************


2022-11-30T21:09:05  [4512167424] INFO  GoogleCloudProvider[googlecloud] apply: making 2 changes to yokishava.dev.
2022-11-30T21:09:08  [4512167424] INFO  Manager sync:   2 total changes
```

### Result

```

% gcloud dns record-sets list --zone=yokishava-dev
NAME                TYPE  TTL    DATA
yokishava.dev.      NS    21600  ns-cloud-b1.googledomains.com.,ns-cloud-b2.googledomains.com.,ns-cloud-b3.googledomains.com.,ns-cloud-b4.googledomains.com.
yokishava.dev.      SOA   21600  ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300
app.yokishava.dev.  A     3600   34.117.199.108

 % nslookup app.yokishava.dev
Server:		118.238.201.33
Address:	118.238.201.33#53

Non-authoritative answer:
Name:	app.yokishava.dev
Address: 34.117.199.108


```


## Remove

Aレコードを削除

### input

```yaml

---
? ''
: ttl: 21600
  type: NS
  values:
  - ns-cloud-b1.googledomains.com.
  - ns-cloud-b2.googledomains.com.
  - ns-cloud-b3.googledomains.com.
  - ns-cloud-b4.googledomains.com.

```

### Dry Run

```

% octodns-sync --config-file=./octodns/config/staging.yaml
2022-11-30T21:12:02  [4662879744] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T21:12:02  [4662879744] INFO  Manager _config_executor: max_workers=1
2022-11-30T21:12:02  [4662879744] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T21:12:02  [4662879744] INFO  Manager __init__: global_processors=[]
2022-11-30T21:12:02  [4662879744] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T21:12:02  [4662879744] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T21:12:02  [4662879744] INFO  Manager sync: eligible_zones=[], eligible_targets=[], dry_run=True, force=False, plan_output_fh=<stdout>
2022-11-30T21:12:02  [4662879744] INFO  Manager sync:   zone=yokishava.dev.
2022-11-30T21:12:02  [4662879744] INFO  Manager sync:   sources=['config'] -> targets=['googlecloud']
2022-11-30T21:12:02  [4662879744] INFO  YamlProvider[config] populate:   found 1 records, exists=False
2022-11-30T21:12:02  [4662879744] INFO  GoogleCloudProvider[googlecloud] plan: desired=yokishava.dev.
2022-11-30T21:12:03  [4662879744] INFO  GoogleCloudProvider[googlecloud] populate: found 2 records, exists=True
2022-11-30T21:12:03  [4662879744] INFO  GoogleCloudProvider[googlecloud] plan:   Creates=0, Updates=0, Deletes=1, Existing Records=2
2022-11-30T21:12:03  [4662879744] INFO  Plan 
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Delete <ARecord A 3600, app.yokishava.dev., ['34.117.199.108']>
*   Summary: Creates=0, Updates=0, Deletes=1, Existing Records=2
********************************************************************************

```

### Run

```

% octodns-sync --config-file=./octodns/config/staging.yaml --doit
2022-11-30T21:12:30  [4651845120] INFO  Manager __init__: config_file=./octodns/config/staging.yaml (octoDNS 0.9.21)
2022-11-30T21:12:30  [4651845120] INFO  Manager _config_executor: max_workers=1
2022-11-30T21:12:30  [4651845120] INFO  Manager _config_include_meta: include_meta=False
2022-11-30T21:12:30  [4651845120] INFO  Manager __init__: global_processors=[]
2022-11-30T21:12:30  [4651845120] INFO  Manager __init__: provider=config (octodns.provider.yaml 0.9.21)
2022-11-30T21:12:30  [4651845120] INFO  Manager __init__: provider=googlecloud (octodns_googlecloud 0.0.2)
2022-11-30T21:12:30  [4651845120] INFO  Manager sync: eligible_zones=[], eligible_targets=[], dry_run=False, force=False, plan_output_fh=<stdout>
2022-11-30T21:12:30  [4651845120] INFO  Manager sync:   zone=yokishava.dev.
2022-11-30T21:12:30  [4651845120] INFO  Manager sync:   sources=['config'] -> targets=['googlecloud']
2022-11-30T21:12:30  [4651845120] INFO  YamlProvider[config] populate:   found 1 records, exists=False
2022-11-30T21:12:30  [4651845120] INFO  GoogleCloudProvider[googlecloud] plan: desired=yokishava.dev.
2022-11-30T21:12:31  [4651845120] INFO  GoogleCloudProvider[googlecloud] populate: found 2 records, exists=True
2022-11-30T21:12:31  [4651845120] INFO  GoogleCloudProvider[googlecloud] plan:   Creates=0, Updates=0, Deletes=1, Existing Records=2
2022-11-30T21:12:31  [4651845120] INFO  Plan 
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Delete <ARecord A 3600, app.yokishava.dev., ['34.117.199.108']>
*   Summary: Creates=0, Updates=0, Deletes=1, Existing Records=2
********************************************************************************


2022-11-30T21:12:31  [4651845120] INFO  GoogleCloudProvider[googlecloud] apply: making 1 changes to yokishava.dev.
2022-11-30T21:12:37  [4651845120] INFO  Manager sync:   1 total changes

```

### Result

```

% gcloud dns record-sets list --zone=yokishava-dev
NAME            TYPE  TTL    DATA
yokishava.dev.  NS    21600  ns-cloud-b1.googledomains.com.,ns-cloud-b2.googledomains.com.,ns-cloud-b3.googledomains.com.,ns-cloud-b4.googledomains.com.
yokishava.dev.  SOA   21600  ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300

```

## Update


### Input

```yaml
web:
  type: A
  values:
    # - 35.190.10.125
    - 34.117.199.108
```

```

2022-12-02T07:26:52  [4680168960] INFO  Plan
********************************************************************************
* yokishava.dev.
********************************************************************************
* googlecloud (GoogleCloudProvider)
*   Update
*     <ARecord A 3600, web.yokishava.dev., ['35.190.10.125']> ->
*     <ARecord A 3600, web.yokishava.dev., ['34.117.199.108']> (config)
*   Summary: Creates=0, Updates=1, Deletes=0, Existing Records=2
********************************************************************************


```
