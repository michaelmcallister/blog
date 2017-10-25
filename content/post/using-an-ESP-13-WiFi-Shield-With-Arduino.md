+++
categories = ["projects", "iot", "Arduino"]
date = "2017-10-25T22:21:42+11:00"
description = "Scoured the Internet for scraps of information on how to connect your ESP8266 ESP-13 WiFi Shield to Arduino? Here's a quick guide."
keywords = ["esp-13", "duinotech", "Arduino", "ESP8266"]
title = "Using an ESP-13 WiFi Shield with your Arduino"
+++

You may very well be deep in the rabbit hole in your long journey of
trying to make sense of the very little information that exists for the ESP8266 ESP-13 WiFi Shield.

This isn't exactly a plug n' play shield.

This guide aims to document a "Getting Started" guide, by the end of it
you'll be making a TCP connection using the WiFiEsp library to a server and printing the contents via serial.

If you don't already have the hardware, and you are thinking of getting one - my advice is don't do it.
It kinda sucks.

But, if you're reading this - it's probably too late...so read on.

The model you have may vary slightly to what I have. I bought mine on [Jaycar](https://www.jaycar.com.au/Arduino-compatible-esp-13-wifi-shield/p/XC4614)
and looks like this:

![Duinotech](/images/esp13.jpg)

It has the brandname "Duinotech" silk printed on the PCB
but appears to be based off a design from the [Doctors of Intelligence & Technology (DOIT)](http://en.doit.am/)

## Fixing the Baud Rate
So, the first problem is the ESP-13 shields UART is set to 115200 baud.

This is way too fast for the Arduino Uno over software serial. So you need to set the baud to 9600.

But unfortunately the pins for serial are swapped. TX goes RX and vice versa, so you need to seperate the shield and wire it up manually.

**Note:** This is not the same as the serial connection from your PC to the Arduino over USB, which is capable of 115200 baud.

You'll also need to make sure the dip switches are set to "off" (top right in the above picture)

| ESP-13        | Arduni Uno    |
| ------------- |:-------------:|
| Debug Port TX | Uno Pin 1 (TX)|
| Debug Port RX | Uno Pin 0 (RX)|
| Debug Port 5V | Uno 5V        |
| Debug Port GND| Uno GND       |

Feel free to refer to the picture below for how I wired it.

![my-wiring](/images/my_wiring.jpg)

Once you've wired it correctly and powered it on you'll need to look at the serial monitor for the output "ready"

If you see this execute the following AT command to change the baud to 9600

`AT+UART_DEF=9600,8,1,0,0`

If you recieve an "OK" back you can move to the next step.

## Getting it to work

#### Prerequisites
You'll need the WiFiEsp libary.

If you don't already have it in the Arduino IDE navigate to "Sketch -> Include Libary -> Manage Libraries" and search for it.

We'll also have to select new serial pins as the Arduino reserves PIN0 and PIN1 for it's own serial.

So connect jumper wires to match the following:

| ESP-13        | Arduni Uno    |
| ------------- |:-------------:|
| Debug Port TX | Uno Pin 3     |
| Debug Port RX | Uno Pin 2     |

You can attach the shield directly on top of the Arduino with this configuration.

#### Uploading a sketch

Now you'll need to use one of the example sketches provided by the libary.

In the Arduino IDE navigate to "Examples -> WiFiEsp -> WebClient"

There are a few variables you need to substitute such as:

* `SoftwareSerial Serial1(3,2)`
* `char ssid[] = "ssid_goes_here"`
* `char pass[] = "wifi_pass_here"`

Upload the sketch and monitor the serial, hopefully you get the following output!


```
[WiFiEsp] Initializing ESP module
[WiFiEsp] >>> TIMEOUT >>>
[WiFiEsp] >>> TIMEOUT >>>
[WiFiEsp] Initilization successful - 1.5.4
Attempting to connect to WPA SSID: <redacted>
[WiFiEsp] Connected to <redacted>
You're connected to the network
SSID: <redacted>
IP Address: 10.0.0.16
Signal strength (RSSI):-47 dBm

Starting connection to server...
[WiFiEsp] Connecting to Arduino.cc
Connected to server
HTTP/1.1 200 OK
Server: nginx/1.4.2
Date: Wed, 25 Oct 2017 11:49:42 GMT
Content-Type: text/plain
Content-Length: 2263
Last-Modified: Wed, 02 Oct 2013 13:46:47 GMT
Connection: close
Vary: Accept-Encoding
ETag: "524c23c7-8d7"
Accept-Ranges: bytes


           `:;;;,`                      .:;;:.
        .;;;;;;;;;;;`                :;;;;;;;;;;:     TM
      `;;;;;;;;;;;;;;;`            :;;;;;;;;;;;;;;;
     :;;;;;;;;;;;;;;;;;;         `;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;       .;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;:`   `;;;;;;;;;     ,;;;;;;;;.`   .;;;;;;;;
  .;;;;;;,         :;;;;;;;   .;;;;;;;          ;;;;;;;
  ;;;;;;             ;;;;;;;  ;;;;;;,            ;;;;;;.
 ,;;;;;               ;;;;;;.;;;;;;`              ;;;;;;
 ;;;;;.                ;;;;;;;;;;;`      ```       ;;;;;`
 ;;;;;                  ;;;;;;;;;,       ;;;       .;;;;;
`;;;;:                  `;;;;;;;;        ;;;        ;;;;;
,;;;;`    `,,,,,,,,      ;;;;;;;      .,,;;;,,,     ;;;;;
:;;;;`    .;;;;;;;;       ;;;;;,      :;;;;;;;;     ;;;;;
:;;;;`    .;;;;;;;;      `;;;;;;      :;;;;;;;;     ;;;;;
.;;;;.                   ;;;;;;;.        ;;;        ;;;;;
 ;;;;;                  ;;;;;;;;;        ;;;        ;;;;;
 ;;;;;                 .;;;;;;;;;;       ;;;       ;;;;;,
 ;;;;;;               `;;;;;;;;;;;;                ;;;;;
 `;;;;;,             .;;;;;; ;;;;;;;              ;;;;;;
  ;;;;;;:           :;;;;;;.  ;;;;;;;            ;;;;;;
   ;;;;;;;`       .;;;;;;;,    ;;;;;;;;        ;;;;;;;:
    ;;;;;;;;;:,:;;;;;;;;;:      ;;;;;;;;;;:,;;;;;;;;;;
    `;;;;;;;;;;;;;;;;;;;.        ;;;;;;;;;;;;;;;;;;;;
      ;;;;;;;;;;;;;;;;;           :;;;;;;;;;;;;;;;;:
       ,;;;;;;;;;;;;;,              ;;;;;;;;;;;;;;
         .;;;;;;;;;`                  ,;;;;;;;;:




    ;;;   ;;;;;`  ;;;;:  .;;  ;; ,;;;;;, ;;. `;,  ;;;;
    ;;;   ;;:;;;  ;;;;;; .;;  ;; ,;;;;;: ;;; `;, ;;;:;;
   ,;:;   ;;  ;;  ;;  ;; .;;  ;;   ,;,   ;;;,`;, ;;  ;;
   ;; ;:  ;;  ;;  ;;  ;; .;;  ;;   ,;,   ;;;;`;, ;;  ;;.
   ;: ;;  ;;;;;:  ;;  ;; .;;  ;;   ,;,   ;;`;;;, ;;  ;;`
  ,;;;;;  ;;`;;   ;;  ;; .;;  ;;   ,;,   ;; ;;;, ;;  ;;
  ;;  ,;, ;; .;;  ;;;;;:  ;;;;;: ,;;;;;: ;;  ;;, ;;;;;;
  ;;   ;; ;;  ;;` ;;;;.   `;;;:  ,;;;;;, ;;  ;;,  ;;;;

Disconnecting from server...
```
