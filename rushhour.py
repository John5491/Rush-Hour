import sys
from collections import deque
from vehicle import Vehicle
GOAL_STATE = Vehicle('X', 4, 2, 'H')

class RushHour(object):
    
    #Initialise a new Rush hour board
    def __init__(self, v):
        self.vehicleSet = v
    #To hash the board 
    def __hash__(self):
        return hash(self.__repr__())
    
    #Same Vehicle
    def __eq__(self, other):
        return self.vehicleSet == other.vehicleSet
    
    #DIfferent Vehicle
    def __ne__(self, other):
        return not self.__eq__(other)
    
    #Format the board into string
    def __repr__(self):
        string = '-' * 8 + '\n'
        for line in self.get_board():
            string += '|{0}|\n'.format(''.join(line))
        string += '-' * 8 + '\n'
        return string

    #Get methods for board
    def get_board(self):
        
        #Represent the game board in a 2D matrix
        board = [[' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' ']]
        
        #Populate the matrix with the vehicles
        for vehicle in self.vehicleSet:
            x, y = vehicle.x, vehicle.y
            if vehicle.orientation == 'H':
                for i in range(vehicle.length):
                    board[y][x + i] = vehicle.id
            else:
                for i in range(vehicle.length):
                    board[y + i][x] = vehicle.id
        return board
    
    #Check if the board is a solved state
    def solved(self):
        return GOAL_STATE in self.vehicleSet
    
    #Return Iterator/Genarator of next possible moves.
    def moves(self):
        board = self.get_board()
        """Since the object is in a set, it is unordered, every run will have
            different sequence of result"""
        for ve in self.vehicleSet:
            if ve.orientation == 'H':
                #Check left
                if ve.x - 1 >= 0 and board[ve.y][ve.x - 1] == ' ':
                    new_v = Vehicle(ve.id, ve.x - 1, ve.y, ve.orientation)
                    new_vehicleSet = self.vehicleSet.copy()
                    new_vehicleSet.remove(ve)
                    new_vehicleSet.add(new_v)
                    yield RushHour(new_vehicleSet)
                #Check right
                if ve.x + ve.length <= 5 and board[ve.y][ve.x + ve.length] == ' ':
                    new_v = Vehicle(ve.id, ve.x + 1, ve.y, ve.orientation)
                    new_vehicleSet = self.vehicleSet.copy()
                    new_vehicleSet.remove(ve)
                    new_vehicleSet.add(new_v)
                    yield RushHour(new_vehicleSet)
            else:
                #Check up
                if ve.y - 1 >= 0 and board[ve.y - 1][ve.x] == ' ':
                    new_v = Vehicle(ve.id, ve.x, ve.y - 1, ve.orientation)
                    new_vehicleSet = self.vehicleSet.copy()
                    new_vehicleSet.remove(ve)
                    new_vehicleSet.add(new_v)
                    yield RushHour(new_vehicleSet)
                #Check left
                if ve.y + ve.length <= 5 and board[ve.y + ve.length][ve.x] == ' ':
                    new_v = Vehicle(ve.id, ve.x, ve.y + 1, ve.orientation)
                    new_vehicleSet = self.vehicleSet.copy()
                    new_vehicleSet.remove(ve)
                    new_vehicleSet.add(new_v)
                    yield RushHour(new_vehicleSet)
                """Yield is return an iterator"""
                
def initVehicle(rushhour_file):
    #A list to hold vehicleSet
    vehicleSet = []
    for line in rushhour_file:
        line = line[:-1] if line.endswith('\n') else line
        #Convert string into charaters and integers
        id, x, y, orientation = line
        #Initialise all the vehicleSet
        vehicleSet.append(Vehicle(id, int(x), int(y), orientation))
        #[Vehicle(A, 0, 0, H), Vehicle(P, 0, 1, V)...] list
        #{Vehicle(A, 0, 0, H), Vehicle(P, 0, 1, V)...} set
    #Return the rushhour board
    return RushHour(set(vehicleSet))

def format_solution(solution):
    #Generate a list 'steps'
    steps = []
    for i in range(len(solution) - 1):
        board1, board2 = solution[i], solution[i+1]
        #find the moved blocks from both boards
        v1 = list(board1.vehicleSet - board2.vehicleSet)[0]
        v2 = list(board2.vehicleSet - board1.vehicleSet)[0]

        if v1.x < v2.x:
            steps.append('{0}R'.format(v1.id))
        elif v1.x > v2.x:
            steps.append('{0}L'.format(v1.id))
        elif v1.y < v2.y:
            steps.append('{0}D'.format(v1.id))
        elif v1.y > v2.y:
            steps.append('{0}U'.format(v1.id))
    return steps


#BFS algorithm
#Precondition: A rushhour board and maximum depth is passed into this methods
#Postcondition: A dictionary is return with solutions,visited and depth_state
def BFS(x, max_depth):
    
    depth = dict() #The number of states visited at each depth
    visited = set() #Total configuration visited
    solutions = list() #Paths to the goal state

    queue = deque()#double ended queue, can manipulate both side
    queue.appendleft((x, tuple())) #Tuple is a list, cannot change the elements
    while len(queue) != 0:
        
        board, path = queue.pop()
        new_p = path + tuple([board])
        #print(tuple([board]))
        #get the depth + 1, return 0 if doesn't exist
        depth[len(new_p)] = depth.get(len(new_p), 0) + 1

        if max_depth <= len(new_p):
            break
        #Set is unorder, use hash to find
        if board in visited:
            continue
        else:
            visited.add(board)
        if board.solved():
            solutions.append(new_p)
        else:
            queue.extendleft((move, new_p) for move in board.moves())
    return {'visited': visited, 'solutions': solutions, 'depth_states': depth}

if __name__ == '__main__':
    filename = sys.argv[1]
    #context manager to open file
    with open(filename) as rushhour_file:
        rushhour = initVehicle(rushhour_file)
    print(rushhour)

    results = BFS(rushhour, 100)

    print ('{0} Solutions found'.format(len(results['solutions'])))
    with open("Solution.txt","w+") as sol:
        sol.write('{0}'.format('\n'.join(format_solution(results['solutions'][0]))))
        
    for solution in results['solutions']:
        print ('Solution: {0}'.format(', '.join(format_solution(solution))))

    print ('{0} Nodes visited'.format(len(results['visited'])))
