CAR_IDS = {'X', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'}
TRUCK_IDS = {'O', 'P', 'Q', 'R'}

class Vehicle(object):

    def __init__(self, id, x, y, orientation):
        
        #Initialise the vehicle length
        if id in CAR_IDS:
            self.id = id
            self.length = 2
        elif id in TRUCK_IDS:
            self.id = id
            self.length = 3
        else:
            raise ValueError('Invalid id {0}'.format(id))

        #Initialise the vehicle x and y coordinate
        if 0 <= y <= 5:
            self.y = y
        else:
            raise ValueError('Invalid y {0}'.format(y))
        
        if 0 <= x <= 5:
            self.x = x
        else:
            raise ValueError('Invalid x {0}'.format(x))

        #Initialise the vehicles' tail coordinate
        if orientation == 'H':
            self.orientation = orientation
            x_end = self.x + (self.length - 1)
            y_end = self.y
        elif orientation == 'V':
            self.orientation = orientation
            y_end = self.y + (self.length - 1)
            x_end = self.x
        else:
            raise ValueError('Invalid orientation {0}'.format(orientation))
        
        if x_end > 5 or y_end > 5:
            raise ValueError('Invalid configuration')
        
    #Hash into integer
    def __hash__(self):
        return hash(self.__repr__())
    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        return not self.__eq__(other)
    #Create printable representation of the vehicle object
    def __repr__(self):
        return "Vehicle({0}, {1}, {2}, {3})".format(self.id, self.x, self.y,
                                                    self.orientation)
