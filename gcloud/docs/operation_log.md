
すでに存在しているレコードがあるとエラーになってしまった。
つまり、新しく登録するレコードに対してしか適用できない。

```shell

% gcloud dns record-sets import -z=yokishava-dev yokishava.dev.yaml
ERROR: (gcloud.dns.record-sets.import) The following records (name type) already exist: ['hello.yokishava.dev. A', 'welcome.yokishava.dev. A', 'yokishava.dev. NS', 'yokishava.dev. SOA']


```
