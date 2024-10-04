import numpy as np


class CliffWalk:
    '''
    Cliff walking environment - Example 6.6 in Sutton & Barto)
    '''

    def __init__(self, height=4, width=12):
        '''
        Class constructor
        '''
        self.height = height
        self.width = width
        self.grid = np.array([
            ['S'] + (self.width - 2) * ['C'] + ['G'],
            *[['0'] * self.width for _ in range(self.height - 1)]
        ])
        self.rewards = {'S': -1, '0': -1, 'C': -100, 'G': 0}

    def is_terminal(self, state):
        '''
        Checks the termination condition
        '''
        return self.grid[state] in ['C', 'G']

    def get_transition(self, state, action):
        '''
        Computes the resulting state and reward associated to a given transition
        '''

        x, y = state

        if action == 'up':
            next_state = (max(0, x-1), y)
        elif action == 'down':
            next_state = (min(self.height - 1, x+1), y)
        elif action == 'left':
            next_state = (x, max(0, y-1))
        elif action == 'right':
            next_state = (x, min(self.width - 1, y+1))
        else:
            print('Incorrect action!')
            exit

        reward = self.rewards[self.grid[next_state]]

        return next_state, reward

    def __str__(self):
        '''
        Allows grid representation - reversed coordinates!
        '''
        grid_str = ''
        for row in self.grid[::-1]:
            grid_str += ' '.join(row) + '\n'
        return grid_str
