#!/usr/bin/python

from gpiozero import Button

pin_a = Button(5,pull_up=True)         # Rotary encoder pin A connected to GPIO5
pin_b = Button(6,pull_up=True)         # Rotary encoder pin B connected to GPIO6

def pin_a_rising():                    # Pin A event handler
    if pin_b.is_pressed: print("-1")   # pin A rising while A is active is a clockwise turn

def pin_b_rising():                    # Pin B event handler
    if pin_a.is_pressed: print("1")    # pin B rising while A is active is a clockwise turn

pin_a.when_pressed = pin_a_rising      # Register the event handler for pin A
pin_b.when_pressed = pin_b_rising      # Register the event handler for pin B

input("Turn the knob, press Enter to quit.\n")