# *** Imports ***

import vlc
import time
import gpiozero
import queue

# *** Globals ***
volume=50
player=vlc.MediaPlayer("")
eventq = queue.Queue(maxsize=10)

stations = [vlc.Media("http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4fm_mf_p"),
            vlc.Media("http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4lw_mf_p"),
            vlc.Media("http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio3_mf_p"),
            vlc.Media("http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4extra_mf_p"),
            vlc.Media("http://bbcwssc.ic.llnwd.net/stream/bbcwssc_mp1_ws-eieuk")]

# Setup controls
enc_a = gpiozero.Button(17,pull_up=True)         # Rotary encoder pin A connected to GPIO17
enc_b = gpiozero.Button(27,pull_up=True)         # Rotary encoder pin B connected to GPIO27
enc_c = gpiozero.Button(22,pull_up=True)         # Rotary encoder push button connected to GPIO22

sw1_a = gpiozero.DigitalInputDevice(10,pull_up=True)
sw1_b = gpiozero.DigitalInputDevice(9,pull_up=True)
sw1_c = gpiozero.DigitalInputDevice(11,pull_up=True)



# *** Definitions ***

# Event handler definitions

def enc_a_rising():                    # Pin A event handler
    if enc_b.is_pressed: eventq.put('VOLDN')   # pin A rising while B is active is a clockwise turn

def enc_b_rising():                    # Pin B event handler
    if enc_a.is_pressed: eventq.put('VOLUP')    # pin B rising while A is active is a clockwise turn

def enc_c_released():                    # Pin C event handler
    eventq.put('VOLPRESS')

def sw1_changed():
    eventq.put('SW1')

def read_sw1():
    sw1_state=0
    if sw1_a.value:
        if sw1_b.value:
            if sw1_c.value:
                sw1_state=0
            else:
                sw1_state=4
        else:
            if sw1_c.value:
                sw1_state=0
            else:
                sw1_state=5
    else:
        if sw1_b.value:
            if sw1_c.value:
                sw1_state=2
            else:
                sw1_state=3
        else:
            if sw1_c.value:
                sw1_state=1
            else:
                sw1_state=0
    return sw1_state

# Register event handlers
enc_a.when_pressed = enc_a_rising      # Register the event handler for pin A
enc_b.when_pressed = enc_b_rising      # Register the event handler for pin B
enc_c.when_released = enc_c_released      # Register the event handler for pin C

sw1_a.when_activated = sw1_changed
sw1_a.when_deactivated = sw1_changed
sw1_b.when_activated = sw1_changed
sw1_b.when_deactivated = sw1_changed
sw1_c.when_activated = sw1_changed
sw1_c.when_deactivated = sw1_changed

# *** Init ***
current_station=read_sw1()
if current_station:
    player.set_media(stations[current_station])
    player.audio_set_volume(volume)
    player.play()
    time.sleep(60)
    player.stop()
else:
    print("Error: station not set")