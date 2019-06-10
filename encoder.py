#!/usr/bin/python

from gpiozero import Button
import queue

eventq = queue.Queue(maxsize=10)

enc_a = Button(17,pull_up=True)         # Rotary encoder pin A connected to GPIO17
enc_b = Button(27,pull_up=True)         # Rotary encoder pin B connected to GPIO27
enc_c = Button(22,pull_up=True)         # Rotary encoder push button connected to GPIO22

def enc_a_rising():                    # Pin A event handler
    if enc_b.is_pressed: eventq.put(-1)   # pin A rising while B is active is a clockwise turn

def enc_b_rising():                    # Pin B event handler
    if enc_a.is_pressed: eventq.put(1)    # pin B rising while A is active is a clockwise turn

def enc_c_rising():                    # Pin C event handler
    eventq.put(2)    

enc_a.when_pressed = enc_a_rising      # Register the event handler for pin A
enc_b.when_pressed = enc_b_rising      # Register the event handler for pin B
enc_c.when_pressed = enc_c_rising      # Register the event handler for pin C

while True:
    message = eventq.get()
    print(message)
