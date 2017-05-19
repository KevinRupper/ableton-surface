import Live
import Network

from _Framework.ControlSurface import ControlSurface

from _Framework.TransportComponent import TransportComponent

from _Framework.ButtonElement import ButtonElement

class SurfaceController(ControlSurface):

	def __init__(self, c_instance):
		ControlSurface.__init__(self, c_instance)

		self.network = Network.Network()



