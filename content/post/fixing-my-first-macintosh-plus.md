---
title: "Turning a frown upside down on a Macintosh Plus"
date: "2022-04-30T22:51:28+10:00"
Description: "My recent adventure in diagnosing and repairing a Macintosh Plus displaying a Sad Mac 0300FF"
Tags: ["macintosh", macintosh plus", "sad mac", "0300ff", "classic mac"]
Categories: []
DisableComments: false
---

I've recently taken an interest in retro computers, particularly classic Macintosh computers. Something about the all-in-one beige design is really appealing to me. Unfortunately, they're quite difficult to get a hold of in Australia for reasonable prices.

You can imagine my surprise when I was able to find one on eBay for about $180AUD, but unfortunately the catch was that it didn't work.

When it booted I initially was greeted with a Sad Mac (0300FF) and some on-screen artifacts, a subsequent reboot deteriorated rapidly and the error code was almost unreadable.

![Sad Mac 0300FF](/images/sad_mac_1.jpg)
![Sad Mac 0300FF #2](/images/sad_mac_2.jpg)

Various guides on the Internet, namely [this one](https://udcf.gla.ac.uk/~gwm1h/Error_Codes/Sad_Mac_Codes.html) indicate that this could potentially be a memory issue.

The first two character represent the class code (in my case 03)

| Class Code                           | Sub Code             |
|--------------------------------------|----------------------|
| 1 = ROM test failed                  | Meaningless          |
| 2 = Memory test - bus subtest        | identifies bad chips |
| 3 = Memory test - byte write         | identifies bad chips |
| 4 = Memory test - Mod3 test          | identifies bad chips |
| 5 = Memory test - address uniqueness | identifies bad chips |

Further digging on the Internet didn't find too much information on this error, other than a confirmation that this is indeed memory related, and possibly due to the wrong speed on the memory modules.

After removing the modules from the logic board, it seemed clear to me that these were not the originally installed modules, and were likely taken from a different machine.

![Bad RAM](/images/bad_ram.jpg)

Luckily, I had bought a logic board for a Macintosh Plus (along with a Macintosh 512ke) that contained some memory modules and made it easy to test out this theory.

I swapped them out, crossed my fingers and it booted just fine with no nightmare screen artifacts

![Happy Mac](/images/happy_mac.jpg)

Now I can can move onto what I originally intended to do with this thing, writing code!