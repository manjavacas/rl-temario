import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches


class Maze:
    '''
    Gridworld maze environment class.
    See example 8.1 in Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
    '''

    def __init__(self, height, width, start_pos, goal_pos, wall_pos):
        '''
        Class constructor.

        Parameters:
            height (int): Height of the grid.
            width (int): Width of the grid.
            start_pos (tuple): Starting position in the grid (y, x).
            goal_pos (tuple): Goal position in the grid (y, x).
            wall_pos (list of tuples): List of wall positions in the grid, each as a tuple (y, x).
        '''
        self.height = height
        self.width = width
        self.start_pos = start_pos
        self.goal_pos = goal_pos
        self.wall_pos = wall_pos

        self.grid = self.__make_grid()

    def step(self, state, action):
        '''
        Takes an action in the environment and returns the next state, reward, and end.

        Parameters:
            state (tuple): Current position in the grid (y, x).
            action (str): Action to take ('up', 'down', 'left', 'right').

        Returns:
            next_state (tuple): New position in the grid after taking the action.
            reward (int): Reward received after taking the action.
            end (bool): Whether the goal has been reached.
        '''
        y, x = state

        if action == 'up':
            new_state = (max(0, y - 1), x)
        elif action == 'down':
            new_state = (min(self.height - 1, y + 1), x)
        elif action == 'left':
            new_state = (y, max(0, x - 1))
        elif action == 'right':
            new_state = (y, min(self.width - 1, x + 1))
        else:
            raise ValueError(
                "Invalid action. Valid actions are 'up', 'down', 'left', 'right'.")

        # Check for wall collision
        if self.grid[new_state] == 'W':
            new_state = state

        # Check if the goal has been reached
        if new_state == self.goal_pos:
            reward = 1
            end = True
        else:
            reward = -1
            end = False

        return new_state, reward, end

    def __make_grid(self):
        '''
        Returns a 2-D grid given start, goal and wall positions.

        Returns:
            np.ndarray: 2-D grid with start, goal, and wall positions.
        '''
        grid = np.full((self.height, self.width), '_')

        grid[self.start_pos] = 'S'
        grid[self.goal_pos] = 'G'

        for pos in self.wall_pos:
            grid[pos] = 'W'

        return grid

    def __str__(self):
        '''
        Returns a string representation of the grid.

        Returns:
            str: String representation of the grid.
        '''
        return '\n'.join(' '.join(row) for row in self.grid)

    def draw(self):
        '''
        Draws the grid using matplotlib.
        '''
        _, ax = plt.subplots()
        ax.set_aspect('equal')
        ax.set_xticks(np.arange(self.width + 1) - 0.5)
        ax.set_yticks(np.arange(self.height + 1) - 0.5)
        ax.set_xticklabels([])
        ax.set_yticklabels([])
        plt.grid(True)

        for y in range(self.height):
            for x in range(self.width):
                if self.grid[y, x] == 'S':
                    ax.add_patch(patches.Rectangle(
                        (x - 0.5, y - 0.5), 1, 1, edgecolor='black', facecolor='green'))
                elif self.grid[y, x] == 'G':
                    ax.add_patch(patches.Rectangle(
                        (x - 0.5, y - 0.5), 1, 1, edgecolor='black', facecolor='red'))
                elif self.grid[y, x] == 'W':
                    ax.add_patch(patches.Rectangle(
                        (x - 0.5, y - 0.5), 1, 1, edgecolor='black', facecolor='black'))
                else:
                    ax.add_patch(patches.Rectangle(
                        (x - 0.5, y - 0.5), 1, 1, edgecolor='black', facecolor='white'))

        plt.gca().invert_yaxis()
        plt.show()
