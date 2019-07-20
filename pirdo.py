# *** Imports ***

import vlc
import time
import gpiozero
import queue
import configparser

# *** Globals ***
volume=50
player=vlc.MediaPlayer("")
eventq = queue.Queue(maxsize=10)

# read volume config if available
vconfig = configparser.ConfigParser()
vconfig.read('/home/pi/pirdo/volume.ini')
if vconfig['DEFAULT']['volume']:
    volume = int(vconfig['DEFAULT']['volume'])

# read vstations config if available
sconfig = configparser.ConfigParser()
sconfig.read('/home/pi/pirdo/stations.ini')

stations = [vlc.Media(sconfig['SW2A']['A']),
            vlc.Media(sconfig['SW2A']['B']),
            vlc.Media(sconfig['SW2A']['C']),
            vlc.Media(sconfig['SW2A']['D']),
            vlc.Media(sconfig['SW2A']['E']),
            vlc.Media(sconfig['SW2B']['A']),
            vlc.Media(sconfig['SW2B']['B']),
            vlc.Media(sconfig['SW2B']['C']),
            vlc.Media(sconfig['SW2B']['D']),
            vlc.Media(sconfig['SW2B']['E']),
            vlc.Media(sconfig['SW2C']['A']),
            vlc.Media(sconfig['SW2C']['B']),
            vlc.Media(sconfig['SW2C']['C']),
            vlc.Media(sconfig['SW2C']['D']),
            vlc.Media(sconfig['SW2C']['E']),
            vlc.Media(sconfig['SW2D']['A']),
            vlc.Media(sconfig['SW2D']['B']),
            vlc.Media(sconfig['SW2D']['C']),
            vlc.Media(sconfig['SW2D']['D']),
            vlc.Media(sconfig['SW2D']['E']),
            vlc.Media(sconfig['SW2E']['A']),
            vlc.Media(sconfig['SW2E']['B']),
            vlc.Media(sconfig['SW2E']['C']),
            vlc.Media(sconfig['SW2E']['D']),
            vlc.Media(sconfig['SW2E']['E'])]

# Setup controls
enc_a = gpiozero.Button(17)         # Rotary encoder pin A connected to GPIO17
enc_b = gpiozero.Button(27)         # Rotary encoder pin B connected to GPIO27
enc_c = gpiozero.Button(22)         # Rotary encoder push button connected to GPIO22

sw1_a = gpiozero.DigitalInputDevice(10,pull_up=True)
sw1_b = gpiozero.DigitalInputDevice(9,pull_up=True)
sw1_c = gpiozero.DigitalInputDevice(11,pull_up=True)

sw2_a = gpiozero.DigitalInputDevice(7,pull_up=True)
sw2_b = gpiozero.DigitalInputDevice(8,pull_up=True)
sw2_c = gpiozero.DigitalInputDevice(25,pull_up=True)

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

def sw2_changed():
    eventq.put('SW2')

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

def read_sw2():
    sw2_state=0
    if sw2_a.value:
        if sw2_b.value:
            if sw2_c.value:
                sw2_state=0
            else:
                sw2_state=4
        else:
            if sw2_c.value:
                sw2_state=0
            else:
                sw2_state=5
    else:
        if sw2_b.value:
            if sw2_c.value:
                sw2_state=2
            else:
                sw2_state=3
        else:
            if sw2_c.value:
                sw2_state=1
            else:
                sw2_state=0
    return sw2_state

def get_station_number():
  sw1_pos = read_sw1()
  sw2_pos = read_sw2()
  snum = (sw1_pos - 1) + ((sw2_pos - 1) * 5)
  return snum

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

sw2_a.when_activated = sw2_changed
sw2_a.when_deactivated = sw2_changed
sw2_b.when_activated = sw2_changed
sw2_b.when_deactivated = sw2_changed
sw2_c.when_activated = sw2_changed
sw2_c.when_deactivated = sw2_changed

# *** Init ***
current_station=get_station_number()
if current_station:
    player.set_media(stations[current_station-1])
    player.audio_set_volume(volume)
    player.play()
    playing = True
    
while True:
    if playing:
        if not player.is_playing():
            player.play()
            time.sleep(5)
    if eventq.not_empty:
        event = eventq.get()
        if event == 'VOLDN':
            volume -= 1
            if volume < 0:
                volume = 0
            player.audio_set_volume(volume)
        elif event == 'VOLUP':
            volume += 1
            if volume > 100:
                volume = 100
            player.audio_set_volume(volume)
        elif event == 'VOLPRESS':
            if playing:
                player.stop()
                playing = False
                vconfig['DEFAULT']['volume'] = str(volume)
                with open('/home/pi/pirdo/volume.ini', 'w') as configfile:
                    vconfig.write(configfile)
            else:
                player.play()
                playing = True
        elif event == 'SW1':
            new_station = get_station_number()
            if new_station:
                if new_station != current_station:
                    current_station = new_station
                    player.stop()
                    player.set_media(stations[current_station-1])
                    player.play()
        elif event == 'SW2':
            new_station = get_station_number()
            if new_station:
                if new_station != current_station:
                    current_station = new_station
                    player.stop()
                    player.set_media(stations[current_station-1])
                    player.play()