# NeoPixel library strandtest example
# Author: Tony DiCola (tony@tonydicola.com)
#
# Direct port of the Arduino NeoPixel library strandtest example.  Showcases
# various animations on a strip of NeoPixels.
import optparse
import time
import matplotlib
matplotlib.use("TkAgg")
import matplotlib.pyplot as plt
from Controls       import *                # General application parameters and logic
from audioFFT 		import AudioStream

#from neopixel import *

########################################################################################################
""" Parse for Plots """
plot = False
parser = optparse.OptionParser()    
parser.add_option(
    '-p', 
    '--plot',
    action = "store_true",
    default= False,
    dest   = "plot",
    help   = "Prints plots, only when in GUI")
########################################################################################################

# LED strip configuration:
LED_COUNT      = 150      # Number of LED pixels.
LED_PIN        = 18      # GPIO pin connected to the pixels (must support PWM!).
LED_FREQ_HZ    = 800000  # LED signal frequency in hertz (usually 800khz)
LED_DMA        = 5       # DMA channel to use for generating signal (try 5)
LED_BRIGHTNESS = 255     # Set to 0 for darkest and 255 for brightest
LED_INVERT     = False   # True to invert the signal (when using NPN transistor level shift)

class Neurogenesis:

	def __init__(self):
		audioObject = AudioStream(SR, BUFFERSIZE, BITRES, False)               
		audioObject.inStream.start_stream()
		while (audioObject.audioStarted == 0):1#loop to wait the audio to start
		audio       = audioObject.audio
		audioFFT    = audioObject.audioFFT            
		print 'Start Audio Stream'
		print "Sampling rate (Hz):\t"    + str(SR)
		print "Hz per Bin:\t\t"          + str(SR/BUFFERSIZE)
		print "Buffersize:\t\t"          + str(BUFFERSIZE)

		try:
			

			print "Press Ctrl-C to quit."


			"""
			Setup the plot
			Use the bandpass filter frequency range as the x-axis
			Rescale the y-axis
			"""
			####################################################### PLOT  #############
			plt.ion()
			#bin = range(self.highpass,self.lowpass)
			#xs = numpy.arange(len(bin))*rate/self.buffersize + highHertz
			self.freqPlot = plt.plot(range(PLOT_WIDTH),range(PLOT_WIDTH))[0]
			#plt.ylim(0, 10**12)
			plt.ylim(0, 100)
			#plt.ylim(0, BUFFERSIZE*(2**16))

			while True:
		
				""" AUDIO STREAM  - ...      """
				if AUDIO:
					audio       = audioObject.audio
					audioFFT    = audioObject.audioFFT
				"""---------------------------------------------------------------------------------------"""
				
				self.freqPlot.set_ydata(audioFFT[0:PLOT_WIDTH])
				#self.freqPlot.set_ydata(self.audio)
				plt.show(block = False) 
				#plt.show()
				plt.draw()

				# Neuron Firing
				intensity1 = int(255 * audioFFT[10])
				intensity2 = int(255 * audioFFT[20])
				intensity3 = int(255 * audioFFT[30])
				#self.flashSpark(strip, Color(intensity1,intensity1,intensity1), 1   ) #White
				#self.flashSpark(strip, Color(intensity2,intensity2,intensity2), 0.1 ) #White
				#self.flashSpark(strip, Color(intensity3,intensity3,intensity3), 0.01) #White


		except KeyboardInterrupt:
			MODEL_RUN  = 0
			print 'Stop - Exception - Keyboard Interrupt'
			pass

		except Exception, err:
			MODEL_RUN  = 0
			print 'Stop - Exception - Error'
			print err
			pass


	# Define functions which animate LEDs in various ways.
	def flashSpark(strip, color, wait_ms=1):
		"""Wipe color across display a pixel at a time."""
		for i in range(strip.numPixels()):
			strip.setPixelColor(i, color)
			strip.show()
			time.sleep(wait_ms/10000.0)
			strip.setPixelColor(i, 0)



# Main program logic follows:
if __name__ == '__main__':

	#(options, args) = parser.parse_args()
    #plot = options.plot

	# Create NeoPixel object with appropriate configuration.
	#strip = Adafruit_NeoPixel(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS)
	# Intialize the library (must be called once before other functions).
	##strip.begin()

	Neurogenesis() # Start this process

	



