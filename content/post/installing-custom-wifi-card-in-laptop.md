+++
categories = ["projects"]
date = "2019-03-04T01:00:00Z"
description = "or, how I got rid of the pesky 'Error Message: 104-Unsupported wireless network device detected. System Halted.'"
keywords = ["HP Mini 110-3000","Error 104","Unsupported wireless network device detected", "RT3090"]
title = "Upgrading my HP Mini-110 with better WiFi (the hard way)"
+++


I've had my HP Mini 110-3000 for a while now, at least since 2011 and it's one
of my favourite laptops ever.

Why? Well, it's got:

- 3 USB ports (sure, it's only USB 2.0)
- a VGA port
- SD card reader
- 10 inch screen, perfectly portable!

It originally came with Windows XP, a slow HDD and 1Gb of RAM but I quickly
moved to Linux (duh), doubled the RAM and put an SSD in.

I use it heavily in my lab to console to my networking devices when I've lost
out of band, or if I need something on the go.

There was just one user customizable part left to upgrade, and that was the WiFi
card. The original one was based on the `Realtek RT3090` chipset, limited to
2.4Ghz and only b/g/n. I would struggle to push more than 25Mbs on it.

One of the best things about this ultra portable laptop is how easy it is to add
parts, I just take the backpanel off (no screwdrivers needed) to reveal all the
components.

![104 Error](/images/back-laptop.jpg)

So off I went to install a different card I had laying around, based on the
`Broadcom BCM943224` (honestly, it's not much better but it supports 5Ghz at
least).

Installation was easy enough but I was prompted by a screen as soon as I turned
it on.

![104 Error](/images/unsupported-wireless-network.jpg)

I couldn't even get into the BIOS, and there was no way around this. I don't
replace cards in laptops often so I didn't even know this was a thing, it seems
like a dick move - especially since I could use a usb WiFi dongle no problem and
even a different mini PCI-e slot works, so I don't buy that it's FCC
regulations. Seems to me that it's just artificially limiting what cards I can
use so I have to buy them through HP.

Anyway, the fine people at [bios-mods.com](https://www.bios-mods.com/) are all
too familiar with this problem, and a number of users have actually modified the
bios to get around it.

# Obtaining the modified BIOS

It's tricky to find the exact BIOS needed for your model, but with enough
Google-fu you'll get there.

Google search queries limited to bios-mods.com helped me find mine:
`hp mini 110 site:bios-mods.com`

Also searching for the BIOS installer name (eg. `sp56497.exe`) helped.

If there's anyone out there still using this laptop (doubtful, it's almost 10
years old!) skip to the bottom to get the necessary files that I've rehosted.

# Installing the BIOS

For Linux users, this is not as straight forward as I would've liked. I was able
to extract the `.bin` file from the exe easy enough, but found no way to
actually apply it. I had read that Insyde BIOS has a way to force an install by
holding `super + B` during boot, but this didn't help. Neither did HP's official
rescue boot drives as they required the BIOS file to be signed.

The only way was to run the installer within Windows 7. Windows 10 in
compatibility mode **does NOT work**.

After installing Windows 7 temporarily, it was a simple as running the installer
which flashed the updated BIOS no problem.

If you know of a way to install Insyde BIOS updates from Linux, or the BIOS
please leave a comment :-)

# Summary

Running into the
`104-Unsupported wireless network device detected. System Halted.` error?

The only way around it is to use a modified BIOS, hopefully one has already been
created for you.

If you've got any ideas for hardware hacks for this laptop, I'd love to hear
them!

## Files:

- [HP Mini 110-3000 modified BIOS](/dl/sp51731_NWL_ByCamiloml.exe)