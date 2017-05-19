from socket import *
import time

UDP_IP = "127.0.0.1"
UDP_PORT = 5005
MESSAGE = "Hello, World!"

class Network:
    def __init__(self):

        self.server_address = ('192.168.1.14', 9000)
        # Create a UDP socket
        self.sock = socket(AF_INET, SOCK_DGRAM)

        # Bind the socket
        print 'starting up on localhost port 9000'
        address = ('localhost', 9000)
        # self.sock.bind(address)
        #
        # self.sock.sendto(bytes(MESSAGE), server_address)

    def start(self):
        while True:
            time.sleep(5)
            sent = self.sock.sendto("Hello", self.server_address)
            print 'Sent'
            # print '\nWaiting to receive message'
            # data, address = self.sock.recvfrom(4096)
            #
            # print 'received %s bytes from %s' % (len(data), address)
            # print data

            # if data:
            #     sent = self.sock.sendto(data, address)
            #     #print 'Sent back to %s' % address
            #     self.sock.sendto(bytes(MESSAGE), ("127.0.0.1", 9000))


    def sendMessage(self):
        print 'Send message'
        self.sock.sendto(bytes(MESSAGE), ("127.0.0.1", 9000))