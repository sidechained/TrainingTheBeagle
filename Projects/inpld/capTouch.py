# capTouch.py - a port of CapTouch from the Arduino CapSense library

# Links to the original C++ files here:
# https://github.com/moderndevice/CapSense/blob/master/CapTouch.cpp
# https://github.com/moderndevice/CapSense/blob/master/CapTouch.h

# To Do:
# - check that time.clock will actually work as an approach for measuring elapsed time (i.e. that its output can be compared with timeoutCount
# - what is an appropriate value for timeoutCount?

# Requirements:
# This capacitive sensing method requires two microcontroller pins (send pin, receive pin)
# with a high value resistor between them (1M is a starting point)
# a small capacitor (20-40 pf) from the receive pin (the sensor is connected to this pin)
# to ground will result in more stable readings. Sensor is any wire or conductive foil
# on the receive pin.

import time
import Adafruit_BBIO.GPIO as GPIO

class CapTouch:

	# CONSTRUCTOR:
	# Function that handles the creation and setup of instances

	def __init__(self, argSendPin,argReceivePin):
		timeoutCount = 40000000 # originally = 40000000L 
		sendPin = argSendPin
		receivePin = argReceivePin
		calibrateFlag = 0 # uncalibrated on startup
		GPIO.setup(sendPin, GPIO.OUT) #set sendpin to OUTPUT

	# PUBLIC METHODS:
	# Functions available in Wiring sketches, this library, and other libraries

	def readTouch(self, samples):
		total = 0
    		if calibrateFlag is 0 or samples is not equal to lastSamples:
    		# calibratess the baseline value
    		# first time after powerup or reset calibrates the sensor with baseline
    		# so sensor should be in "untouched" state at powerup
		calibrateTouch(samples)
		lastSamples = samples
		calibrateFlag = 1

		# THEORY: Set the GPIO pin as an output and set it Low.
		# This discharges any charge in the capacitor and ensures that both sides of the capacitor are 0V.

		for i in range(samples): # for (i = 0; i < samples; i++):
			# THEORY: Set the GPIO pin as an input.
			# This starts a flow of current through the resistors and through the capacitor to ground.
			# The voltage across the capacitor starts to rise.
			# The time it takes is proportional to the resistance of the LDR (the capacitance of the touched electrode). following t=R*C
			GPIO.setup(receivePin, GPIO.IN) # set receive pin to input
			GPIO.output(receivePin, GPIO.LOW) # set receive pin (pullups off)
			GPIO.setup(receivePin, GPIO.OUT) # set to OUTPUT to discharge circuit
			GPIO.setup(receivePin, GPIO.IN) # set pin to INPUT
			GPIO.output(sendPin, GPIO.HIGH) # set send pin High

			while GPIO.input(receivePin) is 0 and total is less than timeoutCount: # while receive pin is LOW AND total is positive value 
				# THEORY: Monitor the GPIO pin and read its value. Increment a counter while we wait.
				total = total + 1

			if total is greater than or equal to timeoutCount:
				return -2 # total variable over timeout

			# THEORY: At some point the capacitor voltage will increase enough to be considered as a High by the GPIO pin (approx 2v).
			# The time taken is proportional to the resistance (capacitance) level coming from the LDR (the touched electrode).
			# set receive pin HIGH briefly to charge up fully - because the while loop above will exit when pin is ~ 2.5V

			# THEORY: Set the GPIO pin as an output and repeat the process as required.
        
			GPIO.output(receivePin, GPIO.HIGH) # set receive pin HIGH (pullup on)
        		GPIO.setup(receivePin, GPIO.OUT) # set pin to OUTPUT - pin is now HIGH AND OUTPUT
        		GPIO.setup(receivePin, GPIO.IN) # set pin to INPUT
        		GPIO.output(receivePin, GPIO.LOW) # turn off pullup
        		GPIO.output(sendPin, GPIO.LOW) # set send Pin LOW

			while GPIO.input(receivePin) is 1 and total is less than timeoutCount:
				total++

	if total is greater than or equal to timeoutCount:
 		# return an error
		return -2     # total variable over timeout
	else:
    		total = total - baselineR; # baselineR is set in calibration function
    		if total is less than 0 return 0
		return total

	def calibrateTouch(self, samples):

		# the idea here is to calibrate for the same number of samples that are specified
		# but to make sure that the value is over a certain number of powerline cycles to
		# average out powerline errors

		GPIO.setup(sendPin, GPIO.OUT) # set Send pin Output
		start = time.clock()
		while time.clock() - start is less than calibrateTime:

			for i in range(samples): # for (i = 0; i < samples; i++):            
				GPIO.setup(receivePin, GPIO.IN) # set receive pin to input
				GPIO.output(receivePin, GPIO.LOW) # set receive pin low (pullups off    )
				GPIO.setup(receivePin, GPIO.OUT) # OUTPUT to discharge circuit
				GPIO.setup(receivePin, GPIO.IN) # set pin to INPUT
				GPIO.output(sendPin, GPIO.HIGH) # set send pin High
           
				while GPIO.input(receivePin) is 0 and total is less than timeoutCount:
				# while receive pin is LOW AND total is positive value
                		total = total + 1

            			if total >= timeoutCount:
                			return -2 # total variable over timeout
            			# set receive pin HIGH briefly to charge up fully
				# because the while loop above will exit when pin is ~ 2.5V
					GPIO.output(receivePin, GPIO.HIGH) # set receive pin HIGH (pullup on)
					GPIO.setup(receivePin, GPIO.OUT) # set pin to OUTPUT
					GPIO.setup(receivePin, GPIO.IN) # set pin to INPUT
					GPIO.output(receivePin, GPIO.LOW) # turn off pullup
					GPIO.output(sendPin, GPIO.LOW) # set send Pin LOW
            
				while GPIO.input(receivePin) is 1 and total is less than timeoutCount:
                		total = total + 1
				j = j + 1

		if total is greater than or equal to timeoutCount:
			return -2 # total variable over timeout
			print "calibrate routine over timeout, check wiring or raise  'timeoutCount’"
		else:
			baselineR = total / j
			print "total = '{0}' baselineR = ‘{1}’”.format(total, baselineR)
