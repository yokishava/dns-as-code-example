var REG = NewRegistrar('none');    // No registrar.
var DNS_BIND = NewDnsProvider('gcloud');  // ISC BIND.

// Domains:

var FIREBASE_HOSTING_SITES = [
  A('hello', '199.36.158.100'),
  A('welcome', '199.36.158.100'),
  A('world', '199.36.158.100'),
  A('web', '199.36.158.100'),
];

D('yokishava.dev', REG, DnsProvider(DNS_BIND),
    NAMESERVER_TTL('21600'),
    DefaultTTL('3600'),
    FIREBASE_HOSTING_SITES
);
