#!/usr/bin/python3

'''
Custom implementation of the Dyna-Q algorithm from
Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: 
An introduction (2nd ed.). MIT press.

Author: Antonio Manjavacas
'''

from grid_maze import Maze
from dynaq import DynaQ

import matplotlib.pyplot as plt

GRID_HEIGHT = 6
GRID_WIDTH = 9

START_POSITION = (2, 0)
GOAL_POSITION = (0, 8)
WALL_POSITIONS = [(1, 2), (2, 2), (3, 2), (0, 7), (1, 7), (2, 7), (4, 5)]


maze = Maze(GRID_HEIGHT, GRID_WIDTH, START_POSITION,
            GOAL_POSITION, WALL_POSITIONS)

# maze.draw()

########## SINGLE AGENT TESTING ##########

# agent = DynaQ()
# rewards = agent.learn(maze)

# plt.plot(rewards)
# plt.xlabel('Episode')
# plt.ylabel('Total Reward')
# plt.title('Dynaq Total Reward per Episode')
# plt.grid(True)
# plt.show()

########## COMPARISON OF SEVERAL AGENTS ##########

results = {}

plan_steps = [0, 5, 10, 50]

for plan_steps in plan_steps:
    agent = DynaQ(plan_steps=plan_steps)
    rewards = agent.learn(maze, plan_steps=plan_steps)
    results[plan_steps] = [-r for r in rewards]


plt.figure(figsize=(10, 6))
for plan_steps, rewards in results.items():
    plt.plot(rewards, label=f'plan_steps={plan_steps}')
plt.xlabel('Episode')
plt.ylabel('Episode steps')
plt.title('Comparison of DynaQ Agents with Different planning steps')
plt.legend()
plt.grid(True)
plt.show()
