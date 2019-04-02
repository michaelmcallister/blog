+++
title = "Retrieving Data from a dead phone (Nokia N900)"
date = "2018-10-21T19:16:00+11:00"
description = "How I retrieved data from my dead Nokia N900"
keywords = ["emmc", "phone repair", "data retrieval", "Toshiba THGBM4G4D1HBAIR"]
categories = ["guide"]
toc = true
+++

Don't do this on a device that you ever want to turn on again. This is a last resort, if your phone turns on it's better to do this in software.

# Overview

I'm known to buy a new shiney phone every couple of years, due in part to the fact I use them into the ground and they invetiably break beyond repair.

Recent shifts to cloud backups (particularly for photos with solutions like Google Photos) have meant that it's not too much of an inconvenience to migrate from one phone to another.

Unfortunately, for me I have plenty of phones that predates even the rise of Android. One such phone is the [Nokia N900](https://en.wikipedia.org/wiki/Nokia_N900). For those unfamiliar with this phone; it runs Linux, with a distro that is loosely based on Debian. Maybe it's the nostalgia talking, or my love for Linux but nothing beats that phone.

Like all of my phones, this one is one I loved *too* much, and eventually broke (screen wouldn't turn on, wouldn't charge, etc) and spent the better part of 7 years in the bottom of a drawer.

Read on to see how I de-soldered the storage chip and read it with my computer.

# Where are the files stored?

For most phones released in the last 10 years, an eMMC chip is used for mass storage. In my particular case it was a `Toshiba THGBM4G4D1HBAIR`.

These chips are soldered directly onto the motherboard using a ball grid array (BGA), which are not meant to be user-removable. 

What surprised me however, is that the eMMC/MMC standard is compatible with the SD card standard. Meaning that you can directly solder one of these eMMC cards to an SD card reader and read/write from it using your computer.

Indeed, this has been before and if you've got a steady hand and a lot of patience (something that I very much lack) you can read about it on [Hackaday](https://hackaday.com/2016/11/18/roll-your-own-64gb-sd-card-from-an-emmc-chip/)

Here's a picture of my eMMC chip on the Nokia N900 motherboard

![Nokia N900 motherboard](/images/nokia_n900_motherboard.jpg)

# Procedure

At a high level, it's quite simple to do.

You desolder the eMMC chip, and then you need to read it via the SD card interface.

There are a couple of solutions to read these chips, one is via an adapter and one is by soldering it directly to an SD card reader. Buying the adapter costs more, but is easier and less error prone. Soldering is cheaper, but if you suck as much as I do you'll probably damage the chip forever.

## Desoldering

You can find literally hundreds of videos on YouTube with process on how to do this. 

The easiest way, and what I did was to use a hot air gun heated up to 350C directly applied to the chip on the motherboard. After a minute or so the chip will slide right off.

You'll need to use some flux and Isopropyl alcohol to fully clean the pads of the ball grid array.

Here you can see my chip under a microscope with some flux, and shortly after cleaning it with IPA.

![eMMC with Flux](/images/emmc_dirty.jpg)

![eMMC after cleaning](/images/emmc_clean.jpg)

This part is the hardest, and if you're not familiar with using a heat gun, or flux it may be tricky. 

## Reading it

I purchased my adapter from eBay, specifically this [item](https://www.ebay.com.au/itm/BGA-adapter-eMMC-test-Socket-to-SD-eMMC169-153-for-BGA153-169-for-data-recovery/253829332766?ssPageName=STRK%3AMEBIDX%3AIT&_trksid=p2060353.m2749.l2649)

This adapter has the compartment for the eMMC chip in the centre, and then an SD card like PCB poking out.

![eMMC reader](/images/emmc_reader.jpg)

All it takes from here is placing the chip in the compartment and hoping for the best.

## Retrieving your information

Hopefully when you plug this adapter into your PC it'll immediately detect the storage. This depends on a few factors, including what filesystem the chip is using.

In the case of the Nokia N900, there's 3 partitions:
 * ext3 partition of /home
 * swap partition
 * ~25Gb vfat partition for data

 If you're using Windows you won't have any problem with the vfat partition. You'll need to download some software such as [Ext2FSd](https://sourceforge.net/projects/ext2fsd/) to read this data.

 If you can't read this data, I would recommend *not* using a USB reader and using a PC or Laptop that has an SD card reader built in.

# Conclusion

 It really isn't that tricky to do and I've had some pretty good success.

 Having said that...desoldering a BGA is the easy part. Replacing a chip with another one is the hard part. 

 I throw the mobile phones out when I retrieve the data.

