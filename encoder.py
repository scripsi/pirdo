#!/usr/bin/python

import gpiozero
import queue

eventq = queue.Queue(maxsize=10)

enc_a = gpiozero.Button(17,pull_up=True)         # Rotary encoder pin A connected to GPIO17
enc_b = gpiozero.Button(27,pull_up=True)         # Rotary encoder pin B connected to GPIO27
enc_c = gpiozero.Button(22,pull_up=True)         # Rotary encoder push button connected to GPIO22

sw1_a = gpiozero.DigitalInputDevice(10,pull_up=True)
sw1_b = gpiozero.DigitalInputDevice(9,pull_up=True)
sw1_c = gpiozero.DigitalInputDevice(11,pull_up=True)

def enc_a_rising():                    # Pin A event handler
    if enc_b.is_pressed: eventq.put(-1)   # pin A rising while B is active is a clockwise turn

def enc_b_rising():                    # Pin B event handler
    if enc_a.is_pressed: eventq.put(1)    # pin B rising while A is active is a clockwise turn

def enc_c_released():                    # Pin C event handler
    eventq.put(2)

def sw1_changed():
    sw1_state = sw1_a.value + (sw1_b.value * 2) + (sw1_c.value * 4)
    eventq.put(sw1_state)


enc_a.when_pressed = enc_a_rising      # Register the event handler for pin A
enc_b.when_pressed = enc_b_rising      # Register the event handler for pin B
enc_c.when_released = enc_c_released      # Register the event handler for pin C

sw1_a.when_activated = sw1_changed
sw1_a.when_deactivated = sw1_changed
sw1_b.when_activated = sw1_changed
sw1_b.when_deactivated = sw1_changed
sw1_c.when_activated = sw1_changed
sw1_c.when_deactivated = sw1_changed

while True:
    message = eventq.get()
    print(message)
