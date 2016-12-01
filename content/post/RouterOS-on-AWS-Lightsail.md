+++
categories = ["aws"]
date = "2016-12-01T09:35:10Z"
description = "Use a custom OS for AWS Lightsail, like MikroTiks Cloud Hosted Router!"
keywords = ["AWS, Amazon Web Services, Amazon Lightsail, lightsail, mikrotik, RouterOS"]
title = "RouterOS (or your own!) on AWS Lightsail"

+++

If you haven't already seen, Amazon just released [Lightsail](https://aws.amazon.com/blogs/aws/amazon-lightsail-the-power-of-aws-the-simplicity-of-a-vps/) at this years re:Invent and it's awesome! - I strongly reccomend you check out Jeff Barrs blog post about it.

In a nutshell, it's still the EC2 you know and love but more geared towards users that need something closer to a VPS, rather than leveraging the Cloud (and all the goodness that comes with it, like elasticity and incredible scalability) you get a single instance (a bit more of a pet, than say the rest of your cattle)

What's there to gain from this? Well, how about some very competitive pricing starting at $5 and a very nice simple to use interface!

Unfortunately at this stage you're confined to either Amazon Linux, or Ubuntu...or /are/ you?

I managed to get a MikroTik Cloud Hosted Router working on my lightsail instance and it wasn't hard at all.

# Steps

* Firstly create your Lightsail instance via the [Console](https://lightsail.aws.amazon.com) (I used Ubuntu, but it shouldn't really matter)
* Download the MikroTik Raw Disk image from their [website](http://www.mikrotik.com/download#chr)
* Unzip it onto your local Desktop (or inside your lightsail instance, whatever)
* SCP your image over with a command like: ```scp ~/Downloads/chr-6.38rc37.img ubuntu@34.193.xxx.xxx:/tmp```
* use the DD image to overwrite your disk with this image: ```dd if=/tmp/chr-6.38rc37.img of=/dev/xvda```

## Reboot!

**Note:** You probably won't be able to reboot from inside your instance once you've done this as you've written over the top of your running instance - if you're lucky you might be able to use the Magic SysRq key, like I did:

```bash
root@ip-172-26-xxx-xxx:~# echo 1 > /proc/sys/kernel/sysrq
root@ip-172-26-xxx-xxx:~# echo b > /proc/sysrq-trigger
```
but if not, just use the Lightsail console. 

...and that's it!

Once it's fully rebooted, you should be able to SSH or navigate to the WebUI

Have fun :-)

![MikroTik Console](/images/mikrotik.png)
