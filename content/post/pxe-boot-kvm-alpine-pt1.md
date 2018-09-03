+++
title = "PXE Boot Alpine Linux Pt. 1"
date = "2018-09-03T19:00:00+11:00"
description = "Running Alpine Linux diskless and in-memory booting from the network."
keywords = ["alpine", "kvm", "linux", "virtualisation", "pxe", "diskless"]
categories = ["linux", "homelab"]
toc = true
+++

# Overview

In a [previous post]({{< ref "alpine-as-a-kvm-host" >}}) I outlined the quick and easy steps to setup a *super* lean installation of Alpine Linux to serve as a KVM host. One of the possible ideas to explore that I mentioned was using PXE boot and doing away with disks all together.

In this post I'll go through the steps to get a working instance of Alpine Linux booted from the network. I'll be using my server as a KVM host like my earlier post, but the steps here will be generic enough that you can use it for whatever your purpose is.

Firstly, let's go over the main reasons why we would even want this.

* **No disks** - No disks means less parts to buy (if you don't have a disk already), less things to break, and potentially some cost savings in electricity.
* **More Resillient** - If you replace your single disk server (in my case a NUC) to boot from your NAS that potentially has RAID5/RAID10 you'll have less potential for data corruption (*but you've set your backups properly too, right?*)
* **Easier to upgrade** - I currently have two NUCs: an i3 and an i5. If I want to swap the PXE booted i3 for an i5...I just need to unplug the ethernet cable and plug it into the i5. It'll boot up and look exactly the same, but running on faster hardware.
* **Scale** - My NUC addiction is getting out of hand and I don't have time to manually install base images on them - so why not have a generic image that any new machines can boot into?

This approach is not new, nor revolutionary; you'll find setups like this at places like LAN cafes, libraries and even in the enterprise, and largely for the reasons above.

# Prerequisites

In order to PXE boot you'll need a few things already set up.

* a DHCP server that supports setting PXE options (see [RFC5071](https://tools.ietf.org/html/rfc5071))
* a TFTP server to serve the PXE bootloader
* a HTTP(s)/FTP server to load the kernel, and initramfs
* NFS server for the OS to load kernel modules

I won't go into much detail on how to set each individual component, as it varies depending on whatever solution you are already using. If you run into any problems leave a comment and I'll help you out.

## DHCP

If you're using ISC DHCP you'll want to add some configuration to your `subnet` stanza like so:

```nohighlight
 next-server 10.0.0.28;
 filename "gpxe.kpxe";
 ```

I use a mikrotik switch as my DHCP server and set it like so:

 ```nohighlight
[admin@switch] /ip dhcp-server> set boot-file-name=gpxe.kpxe next-server=10.0.0.28
 ```

The filename is not important, you can name it whatever you like with the kpxe extension as long as you are consistent!

## TFTP Server

I use a QNAP TS-431XeU NAS that has this built in (as well as a HTTP server), but `tftpd-hpa` works just fine

Make sure that there are no ACLs or firewalls in the way. The clients will need to access this over UDP on port 69.

As mentioned previously this is for the PXE bootloader, which I'll go into detail on how to create in the next section.

For now make sure the service is up and running and you've got a TFTP root defined.

## HTTP Server

Any standard web server will do, it doesn't need any fancy options or modules. You could even use `python -mSimpleHTTPServer` if you wanted to.

This will be used to serve the gPXE script, kernel/initramfs and an apkovl if needed (more on this later).

For now, it's enough to just have a basic server up and running on any port you like accessible to the subnet.

# Create a PXE bootloader

This is the initial bootloader that tells the client where to go next for the rest of the files.

The iPXE script allows you to select FTP or HTTP (and a few other protocols actually) to serve them, for our purposes it's probably easier to use HTTP.

## Generating the Image

There is an online tool that can be used to generate an iPXE image at https://rom-o-matic.eu/. 

You'll want to select `UNDI only (.kpxe)` as the output format and embed the bootscript. At a bare minimum you'll want something like:

```nohighlight
dhcp net0
chain http://${net0/next-server}/pxe/gpxe-script
```

However, I use something a bit more robust based on a script I found [here](https://wiki.fogproject.org/wiki/index.php/Building_undionly.kpxe)

```nohighlight
#!ipxe
ifopen
isset ${net0/mac} && dhcp net0 
echo Received DHCP answer on interface net0 && goto proxycheck

:dhcpall
dhcp && goto proxycheck || goto dhcperror

:dhcperror
prompt --key s --timeout 10000 DHCP failed, hit 's' for the iPXE shell; reboot in 10 seconds && shell || reboot

:proxycheck
isset ${proxydhcp/next-server} && set next-server ${proxydhcp/next-server} || goto nextservercheck

:nextservercheck
isset ${next-server} && goto netboot || goto setserv

:setserv
echo -n Please enter tftp server: && read next-server && goto netboot || goto setserv

:netboot
chain http://${net0/next-server}/pxe/gpxe-script ||
prompt --key s --timeout 10000 Chainloading failed, hit 's' for the iPXE shell; reboot in 10 seconds && shell || reboot
```

A really neat thing with iPXE is that you can actually use variables such as `${net0/mac}` to help differentiate yourself to the web server.

This means that you could have a default configuration for all clients and specific ones for certain MAC addresses on a different URL.

For instance my configuration uses:
`http://${next-server}/pxe/${net0/mac}/gpxe-script`

You can read plenty more on the [ipxe website](http://ipxe.org/scripting)

## Troubleshooting

I had troubles getting this to work and resorted to building iPXE from source. If you choose to go this route I recommend using: https://wiki.fogproject.org/wiki/index.php/Building_undionly.kpxe as a reference. If enough people have trouble generating this I'll probably build an online tool much like the rom-o-matic.eu one for people to use.

By the end of this you should have a file named `gpxe.kpxe` (rename it to whatever you've defined in your DHCP server) which needs to be placed in your TFTP root.

# Getting the Kernel

You'll need to download the `netboot` flavour of Alpine linux from their [website](https://alpinelinux.org/downloads/) and extract into your web server. I'd recommend extracting it into a folder called `/boot/`. Make sure you make note of the location for the gPXE script.

# Creating the gPXE script

The initial PXE boot loader you created should now be pointing to your HTTP server to the script we are about to create.

This will define the location for the rest of the boot files you just downloaded, and any additional boot options.

The script needs to be in the location you defined in the previous section. For instance if you had:

`http://${net0/next-server}/pxe/gpxe-script`

then the gpxe-script we are about to create needs to be placed in the `/pxe` folder in the root of your web server.

A basic script referencing the `/boot` folder looks like this:

```nohighlight
#!gpxe
kernel http://${next-server}/pxe/boot/vmlinuz-vanilla ip=dhcp alpine_dev=nfs:${net0/next-server}:/homes/nuc1 alpine_repo=http://nl.alpinelinux.org/alpine/v3.8/main/ modloop=http://${next-server}/pxe/boot/modloop-vanilla
initrd http://${next-server}/pxe/boot/initramfs-vanilla
boot
```

The important parts are the kernel and initrd.

The kernel line allows you to specific some options. In this case I have defined `ip`, `alpine_dev`, `alpine_repo` and `modloop`

* **ip** *Required*

set `ip=dhcp` to use DHCP, or if you'd like to set a specific IP you can use `ip=client-ip::gateway-ip:netmask::[device]:` to specify an IP manually

* **alpine_dev** *Required*

The `alpine_dev` specifies a device used for reference data which must reside on a filesystem; currently, this is only the case for kernel modules.

* **alpine_repo**

If set, `/etc/apk/repositories` will be filled with this. I recommend using `rsync` and having a local copy for faster boot times.

* **modloop**

if the specified file is of http/ftp or https (if wget is installed), the modloop file will be downloaded to the /lib directory and will be mounted afterwards

* **ssh_key**

a HTTP URL to your public SSH key from where you are SSH'ing from. This will allow you to log in without a password. You may not be able to login remotely without this.

You can read info on additional options in the [Alpine Linux wiki](https://wiki.alpinelinux.org/wiki/PXE_boot)

# Putting it all together

At this point you should have the following:

* a DHCP server that points to the TFTP server and file location of the initial bootloader (`gpxe.kpxe`)

* a TFTP server that has the iPXE image that you either compiled yourself or through https://rom-o-matic.eu/. This image will need to have the specific PXE script suited to your network.

* a HTTP server that has the following
 * a folder called `/boot` or similiar that has `vmlinuz-vanilla`, `initramfs-vanilla` and `modloop-vanilla`
* the gPXE script referenced in `gpxe.kpxe`

Boot your server up and make sure the boot order specifies PXE first. With a bit of luck you'll see your server boot up into a nice install of Alpine :-)

You'll soon realize that your changes won't persist across reboots - if you'd like to know how to make sure they do, look out for part II!

# Resources

Hopefully by the time you've read this far you've got it all working, but if not here's some useful resources!

* my copy of [gpxe-script](/pxe/gpxe-script) (hosted on a web server)

* my copy of [gpxe.kpxe](/pxe/gpxe.kpxe) configured to load `http://${next-server}/pxe/${net0/mac}/gpxe-script`

* Alpine Linux wiki on [PXE boot](https://wiki.alpinelinux.org/wiki/PXE_boot)

* Wiki on [building iPXE from source](https://wiki.fogproject.org/wiki/index.php/Building_undionly.kpxe)