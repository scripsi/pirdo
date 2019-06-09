# PiRDO

PiRDO is a Raspberry Pi based client device for the taRDO delayed radio server.

## Installing prerequisites

Set up a Raspberry Pi Zero W attached to a Pimoroni Phat-Beat, with a fresh install of Raspbian Lite on the micro SD card. Get it connected to the WiFi network and make sure it is accessible via SSH.

Edit `/boot/config.txt` with tho following changes:

* uncomment `dtparam=i2s=on` to turn on i2s
* comment out `dtparam=audio=on` to turn off the built-in audio
* add `dtoverlay=i2s-mmap` and `dtoverlay=hifiberry-dac` to the end to enable the Phat-Beat's audio.

It should end up looking like this:

```bash
# /boot/config.txt

...

#dtparam=i2c_arm=on
dtparam=i2s=on
#dtparam=spi=on

...

# dtparam=audio=on

...

# For phat-beat
dtoverlay=i2s-mmap
dtoverlay=hifiberry-dac
```

Now get the Pimoroni optimisations and dependencies for the Phat-Beat without the vu-meter stuff:

```bash
curl -sS http://get.pimoroni.com/pulseaudio | bash
```

Create a file `/etc/asound.conf` with the following:

```
pcm.!default {
 type hw
 card 1
}
ctl.!default {
 type hw
 card 1
}
```

Reboot the Pi. Connect a speaker to the Phat-Beat and test it with:

```bash
speaker-test -c2 -t wav
```

If you hear sounds then all is well. Install VLC without x11:

```bash
sudo apt install vlc-nox
```

This installs a metric tonne of other packages (including, confusingly, some x11 ones), but that's still only about half the dependencies of the full `vlc` package!

Test that VLC works:

```bash
vlc http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4fm_mf_p
```

With any luck you should hear Radio 4 coming from the speaker! Type CTRL-C to exit.

Install Python 3 PIP and git:

```bash
sudo apt install python3-pip git
```

Then install the Python VLC library:

```bash
sudo pip3 install python-vlc
```
That's all the prerequisites set up!

## Installing and configuring PiRDO

Clone the PiRDO repository from GitHub:

```bash
git clone https://github.com/scripsi/pirdo
```

