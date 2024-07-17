#!/usr/bin/env python3

'''
Custom implementation of the SARSA, Q-learnign and Expected
SARSA algorithms from Sutton, R. S., & Barto, A. G. (2018). 
Reinforcement learning: An introduction (2nd ed.). MIT press.

Author: Antonio Manjavacas
'''

from cliff_env import CliffWalk

from sarsa import SARSA
from q_learning import QLearning
from expected_sarsa import ExpSARSA


import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib.animation as animation

import numpy as np


env = CliffWalk()

sarsa = SARSA(env)
qlearn = QLearning(env)
expsarsa = ExpSARSA(env)

n_episodes = 500

sarsa.learn(n_episodes, plot=False)
qlearn.learn(n_episodes, plot=False)
expsarsa.learn(n_episodes, plot=False)

################################ REWARD COMPARISON ################################

plt.figure(figsize=(10, 6))
plt.plot(sarsa.total_rewards, label='SARSA')
plt.plot(qlearn.total_rewards, label='Q-learning')
plt.plot(expsarsa.total_rewards, label='Expected SARSA')
plt.xlabel('Episode')
plt.ylabel('Total Reward')
plt.title('SARSA vs. Q-learning vs. Expected SARSA')
plt.legend()
plt.grid(True)
plt.show()

################################ ANIMATED TRAJECTORY ################################


def cliffwalk_animation(env, agent, title='Agent trajectory'):
    '''
    Animates an agent trajectory based on its Q-table
    '''

    agent_img = mpimg.imread('robot.png')
    fig, ax = plt.subplots(figsize=(env.width, env.height))

    ax.set_xlim(0, env.width)
    ax.set_ylim(0, env.height)
    ax.invert_yaxis()

    ax.set_xticks([])
    ax.set_yticks([])

    ax.grid(True)

    for x in range(env.width + 1):
        ax.axvline(x, color='k', linewidth=1)
    for y in range(env.height + 1):
        ax.axhline(y, color='k', linewidth=1)

    for x in range(env.width):
        for y in range(env.height):
            state = (env.height - 1 - y, x)
            if state == (0, 0):
                ax.add_patch(plt.Rectangle(
                    (x, y), 1, 1, fill=True, color='green', alpha=0.5))
            elif state == (0, env.width - 1):
                ax.add_patch(plt.Rectangle(
                    (x, y), 1, 1, fill=True, color='red', alpha=0.5))
            elif state[0] == 0:
                ax.add_patch(plt.Rectangle(
                    (x, y), 1, 1, fill=True, color='black', alpha=0.5))

    agent_img = np.rot90(agent_img, 2)

    def update_agent(state, img_artist):
        y, x = state
        y = env.height - 1 - y
        img_artist.set_extent([x, x + 1, y, y + 1])

    state = (0, 0)
    img_artist = ax.imshow(agent_img, extent=[
                           state[1], state[1] + 1, env.height - 1 - state[0], env.height - 1 - state[0] + 1])

    def animate(frame):
        nonlocal state
        if env.is_terminal(state):
            return
        actions = agent.q_table[state]
        best_action = max(actions, key=actions.get)
        next_state, _ = env.get_transition(state, best_action)
        update_agent(next_state, img_artist)
        state = next_state

    _ = animation.FuncAnimation(
        fig, animate, frames=200, interval=500, repeat=False)

    plt.title(title)
    plt.show()


cliffwalk_animation(env, sarsa, 'SARSA trajectory')
cliffwalk_animation(env, qlearn, 'Q-LEARNING trajectory')
