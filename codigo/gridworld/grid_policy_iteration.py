#!/usr/bin/python3

'''
Custom implementation of the POLICY ITERATION algorithm from
Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: 
An introduction (2nd ed.). MIT press.

Author: Antonio Manjavacas
'''

import copy

from math import trunc

import numpy as np
import matplotlib.pyplot as plt

SHAPE = (3, 3)
TERMINAL_POSITIONS = [(0, 0)]
#, (SHAPE[0]-1, SHAPE[1]-1)

ACTIONS = ['up', 'right', 'left', 'down']

GAMMA = 1
REWARD = -1


class State():
    '''
    State class. Represents a grid cell
    '''
    def __init__(self, i, j, id):
        self.i = i
        self.j = j
        self.id = id
        self.value = 0

        self.id = id
    def __str__(self):
        return f'({self.i}, {self.j})'

    def __repr__(self):
        return self.__str__()

    def __eq__(self, other):
        if isinstance(other, State):
            return (self.i == other.i) and (self.j == other.j)
        elif isinstance(other, tuple):
            return (self.i == other[0]) and (self.j == other[1])
        return False

    def __hash__(self):
        return hash((self.i, self.j))


def is_terminal(state):
    '''
    Check if a state is terminal
    '''
    return state in TERMINAL_POSITIONS


def get_transition(state, action, states):
    '''
    Evaluate transition from state by applying action
    '''
    if action == 'up':
        next_pos = (max(0, state.i-1), state.j)
    elif action == 'down':
        next_pos = (min(SHAPE[0] - 1, state.i+1), state.j)
    elif action == 'left':
        next_pos = (state.i, max(0, state.j-1))
    elif action == 'right':
        next_pos = (state.i, min(SHAPE[1] - 1, state.j+1))
    else:
        print('Incorrect action!')
        exit

    next_state = None
    for s in states:
        if s == next_pos:
            next_state = s
            break

    return next_state, REWARD


def async_policy_eval(states, pi, theta=0.1):
    '''
    Policy evaluation algorithm. Asynchronous implementation
    '''
    i = 0

    while (True):
        i += 1
        delta = 0
        for state in states:  # loop for each s in S
            if not is_terminal(state):
                v_old = state.value  # v
                v_new = 0  # V(s)

                # V(s) <- ...
                for action in pi[state]:  # sum_a pi(a|s)
                    action_prob = pi[state][action]
                    if action_prob > 0:
                        next_state, reward = get_transition(
                            state, action, states)  # r, s'
                        v_new += action_prob * \
                            (reward + GAMMA * next_state.value)

                state.value = trunc(v_new * 10) / 10  # just one decimal
                delta = max(delta, abs(v_old - v_new))

        if (delta < theta):
            break

    print('Async. policy evaluation iterations = ', i)


def sync_policy_eval(states, pi, theta=0.1):
    '''
    Policy evaluation algorithm. Synchronous implementation
    '''
    i = 0

    while (True):
        i += 1
        delta = 0
        states_old = copy.deepcopy(states)
        for state in states:  # loop for each s in S
            if not is_terminal(state):
                v_old = state.value  # v
                v_new = 0  # V(s)

                # V(s) <- ...
                for action in pi[state]:  # sum_a pi(a|s)
                    action_prob = pi[state][action]
                    if action_prob > 0:
                        next_state, reward = get_transition(
                            state, action, states_old)  # r, s'
                        v_new += action_prob * \
                            (reward + GAMMA * next_state.value)

                state.value = trunc(v_new * 10) / 10  # just one decimal
                delta = max(delta, abs(v_old - v_new))
        

        if (delta < theta):
            break

    print('Sync. policy evaluation iterations = ', i)


def policy_improvement(states, pi):
    '''
    Policy improvement algorithm implementation
    '''
    policy_stable = True

    for state in states:
        if not is_terminal(state):
            # old-action <- pi(s)
            old_actions = [action for action,
                           prob in pi[state].items() if prob > 0]

            # pi(s) <- argmax_a ...
            action_values = {}

            for action in pi[state]:
                action_prob = pi[state][action]
                if action_prob > 0:
                    next_state, reward = get_transition(
                        state, action, states)  # r, s'
                    action_values[action] = reward + GAMMA * next_state.value

            best_actions = [action for action, value in action_values.items(
            ) if value == max(action_values.values())]

            for action in ACTIONS:
                if action in best_actions:
                    pi[state][action] = 1 / len(best_actions)
                else:
                    pi[state][action] = 0

            # if old-action != pi(s)...
            if old_actions != best_actions:
                policy_stable = False

    print('\nStable policy? ', policy_stable)
    return policy_stable


def plot_grid(states, pi):
    ''' 
    Values and policy visualization
    '''
    plt.figure()

    for state in states:
        best_actions = [action for action, value in pi[state].items(
        ) if value == max(pi[state].values())]
        i, j = state.i, state.j

        for action in best_actions:
            dx, dy = 0, 0
            if action == 'up':
                dy = -0.25
            elif action == 'down':
                dy = 0.25
            elif action == 'left':
                dx = -0.25
            elif action == 'right':
                dx = 0.25

            if not is_terminal(state):
                plt.arrow(j, i, dx, dy, head_width=0.1,
                          head_length=0.1, fc='black', ec='lightgray')

        if is_terminal(state):
            plt.plot(j, i, marker='o', markersize=10, color='lightgreen')

        plt.text(j, i, f'S{state.id}\n{state.value}', fontweight='bold',
                 color='black', ha='center', va='center')

    plt.xlim(-0.5, SHAPE[1] - 0.5)
    plt.ylim(-0.5, SHAPE[0] - 0.5)
    plt.xticks(np.arange(0, SHAPE[1], 1))
    plt.yticks(np.arange(0, SHAPE[0], 1))
    plt.grid(False)

    plt.gca().invert_yaxis()
    
    plt.show()


def policy_iteration(states, pi):
    '''
    Policy iteration algorithm
    '''

    plot_grid(states, pi)

    ####################### POLICY ITERATION #######################

    policy_stable = False
    i = 1

    while not policy_stable:

        print(f"\n============= ITERATION {i} =============")

        ####################### POLICY EVALUATION #######################

        # async_policy_eval(states, pi)
        sync_policy_eval(states, pi)

        # Show current state values
        # values = np.reshape([state.value for state in states], SHAPE)
        # print(values)

        ####################### POLICY IMPROVEMENT #######################

        policy_stable = policy_improvement(states, pi)

        # Show current policy
        # for state in states:
        #     if not is_terminal(state):
        #         best_actions = [action for action, value in pi[state].items(
        #         ) if value == max(pi[state].values())]
        #         print(state, best_actions)

        plot_grid(states, pi)
        i += 1


if __name__ == '__main__':
    
    # Initialize states
    states = []
    k = 0
    for i in range(SHAPE[0]):
        for j in range(SHAPE[1]):
            states.append(State(i, j, k))
            k += 1

    # Initialize random policy
    pi = {}
    for state in states:
        pi[state] = {}
        for action in ACTIONS:
            pi[state][action] = 1/len(ACTIONS)
    
    policy_iteration(states, pi)
    
