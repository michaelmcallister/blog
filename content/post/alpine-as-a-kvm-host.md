+++
categories = ["linux", "homelab"]
date = "2017-04-01T21:27:01+11:00"
description = "Running a super lightweight host for KVM"
keywords = ["alpine", "kvm", "linux", "virtualisation"]
title = "Alpine Linux as a KVM host"

+++

![Alpine Linux Logo](/images/alpinelinux-logo.svg)

# Overview

I've recently retired my old desktop (an Intel i3 NUC BOXD34010WYKH) which has served me *very* well for a couple of years now.

I knew this little box would make a great server to host a couple of VMs (and/or containers), but I had to be smart about how I use my resources.

[Alpine Linux](https://alpinelinux.org/) is a super lightweight Linux distribution, my dealings with it so far have been mostly with it serving as a base for Docker containers.

It has some very appealing features such as:

* ~130MB installation size (on disk)
* Clean package management using it's own implemention called ```apk``` (it's *seriously* fast and efficient)
* low memory footprint (BusyBox replaces most UNIX tools)

Whilst outside the scope of what I was looking for, it's got some cool features for security buffs:

* built-in stack smashing protection for userland binaries
* grsecurity Linux kernel patches ([Homepage](https://grsecurity.net/))

I won't detail the installation instructions of Alpine Linux itself, as I'd just be duplicating the great deal of resources that already exist (see [further reading]({{< ref "#further-reading" >}})) but please let me know if you get stuck and I'll be happy to help.

Interesting to note about the installation is that it is possible to load the entire OS into RAM from USB - which can prevent burning out your USB with unecessary read/writes- keep in mind you'll need some storage (NFS is fine) for your KVM images. I installed mine to my SSD, because it was there anyway.

# Installing KVM

Once you've installed Alpine Linux you'll need to install the necessary packages for KVM:

```bash
#install
$ apk add qemu-system-x86_64 qemu-gtk netcat-openbsd libvirt-daemon dbus polkit qemu-img
```

and then enable libvirtd to start at boot

```bash
#enable at boot
$ rc-update add libvirtd
```

# End Result

![virt-manager](/images/kvm-alpine.png)

That's it! You should be able to connect to your KVM host remotely via virt-manager on your local machine and start deploying Virtual Machines.

You'll now have a host with minimal services running:

```bash
$ rc-update -v show | grep "default"
                acpid |      default
              chronyd |      default
                crond |      default
             libvirtd |      default
                 sshd |      default
```

using just over 100M of RAM! (without guests, of course)

```bash
$ free -m
             total       used       free     shared    buffers     cached
Mem:         15958        165      15793          0         10         36
-/+ buffers/cache:        117      15841
Swap:         4095          0       4095
```

# Future Expansion/Ideas

There's definitely more opportunities for fun, here's a few ideas:

* convert this to a PXE boot image and run diskless nodes entirely out of memory (check out [PXE Boot Alpine Linux Pt. 1]({{< ref "pxe-boot-kvm-alpine-pt1" >}}))!

* automate and script the bootstrapping of a ready-to-go .ISO

* start hacking at Alpine Linux and look for even more ways to squeeze memory and CPU cycles

# Further Reading

* Checkout the official documentation for running [Alpine Linux as Xen Dom0](https://wiki.alpinelinux.org/wiki/Xen_Dom0) instead of KVM

* [Alpine Linux homepage](https://alpinelinux.org/about/)

* [Installation instructions](https://wiki.alpinelinux.org/wiki/Installation)
