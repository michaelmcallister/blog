+++
categories = ["projects"]
date = "2017-01-17T04:49:29Z"
description = "Replicating hostnames from DHCP leases into Route53 using Go"
keywords = ["Golang","DNS","MikroTik", "RouterOS"]
title = "Adding DNS records from DHCP leases on a MikroTik device"

+++

In my personal endeavours to sharpen my development skills in Golang I've written a small RESTful API to take a domain name and IP address and update Route53 with these values. I've also had an old friend help out with code-review and bounce ideas off - it definitely still needs some polish.

This isn't terribly ground breaking or complicated - however, when you couple this with MikroTiks powerful [scripting language](http://wiki.mikrotik.com/wiki/Manual:Scripting) you can run a script to automatically replicate the hostname sent by the client in the DHCP request into DNS. The Host Name option is defined in [RFC1533](https://tools.ietf.org/html/rfc1533#section-3.14)

The application is named [DRMU](https://github.com/michaelmcallister/drmu) (pronounced Dr. Moo) - it's the **D**ynamic **R**oute53 **M**ikroTik **U**pdater, although technically it doesn't really have anything to do with MikroTik in itself. It leverages the following libraries:

* [AWS SDK](https://aws.amazon.com/sdk-for-go/) - interface to Route53
* [Viper](https://github.com/spf13/viper) - very easy to use configuration library
* [Goji](https://github.com/goji/goji) - lightweight Web framework that has URL routing

## Installing and Building DRMU

It's as easy as the following commands:

* go get -u github.com/michaelmcallister/drmu
* go build src/github.com/michaelmcallister/drmu/drmu.go


## Configuring DRMU

The config file (./config/app.yaml) must be updated with the following values:

* hostedzone - Zone ID for the Route53 zone you wish to update (eventually I'll integrate a way to look this up within the app)
* listendaddress - what address/interface to listen on (generally 0.0.0.0 if you want to access it from outside the machine)
* listenport - the port for the listenaddress

## Running and Using DRMU

Once configuration is defined you execute the binary as you would anything other binary in your OS (Root is not necessary for binding to high-range ports)

to update a record you need to hit the point as such:

http://listenaddress:listenport/drmu/update/$domain/$ipaddress

DRMU is configured to **UPSERT** records - so changing the IP address will update the A record if it already exists (or create it, if it doesn't)

## Integrating with MikroTik

So now we've established a HTTP REST endpoint we can leverage MikroTik script to update DNS records based on the leases.

This simple script running on a schedule will hit the endpoint, which will of course update records

```
# Domain to be added to your DHCP-clients hostname
:local topdomain;
:set topdomain "dhcp.<DOMAIN>.com";

# Set variables to use
:local hostname;
:local hostip;
:local free;

/ip dhcp-server lease ;
:foreach i in=[find] do={
 /ip dhcp-server lease ;
 :if ([:len [get $i host-name]] > 0) do={
   :set free "true";
   :set hostname ([get $i host-name] . "." . $topdomain);
   :set hostip [get $i address];
   :if ($free = true) do={
     :put ("Adding: " . $hostname . " : " . $hostip ) ;
     /tool fetch url="http://10.1.3.105:8000/drmu/update/$hostname/$hostip"
   }
 }
}
``` 
