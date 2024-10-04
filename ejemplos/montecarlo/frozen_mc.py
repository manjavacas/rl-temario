#!/usr/bin/python3

import gymnasium as gym
import numpy as np

from tqdm import tqdm


def monte_carlo_control(env, n_episodes, gamma=1., epsilon=.5):
    """
    Implementation of the Monte Carlo algorithm for controlling a policy in a given environment.

    Args:
    - env (gymnasium.Env): Gymnasium environment.
    - n_episodes (int): Number of training episodes.
    - gamma (float): Discount factor for future rewards (default: 1.0).
    - epsilon (float): Exploration probability for epsilon-greedy policy (default: 0.5).

    Returns:
    - dict: Optimal policy derived from training.

    """
    returns = {}  # Dictionary to store cumulative returns
    visits = {}   # Dictionary to count visits to each state-action pair
    q_values = {}  # Dictionary to store Q values

    def epsilon_greedy_policy(state):
        """
        Epsilon-greedy policy to select actions based on Q values.

        Args:
        - state: Current state of the environment.

        Returns:
        - int: Action selected by epsilon-greedy policy.

        """
        if np.random.rand() < epsilon:
            return env.action_space.sample()  # Exploration: select a random action
        else:
            if state in q_values:
                # Exploitation: select action with highest Q value
                return np.argmax(q_values[state])
            else:
                return env.action_space.sample()

    # Training loop over a specified number of episodes
    for _ in tqdm(range(n_episodes), desc="Episodes", unit="episode"):

        # Initialization of the episode
        state = env.reset()[0]  # Reset environment and get initial state
        done = False
        episode = []

        # Run the episode until termination
        while not done:
            action = epsilon_greedy_policy(state)
            next_state, reward, done, _, _ = env.step(action)
            episode.append((state, action, reward))
            state = next_state

        # Compute returns
        G = 0
        for t in range(len(episode) - 1, -1, -1):
            state, action, reward = episode[t]
            G = gamma * G + reward

            # Update Q values if (state, action) pair has not been visited in earlier episodes
            if (state, action) not in [(episode[i][0], episode[i][1]) for i in range(t)]:
                if (state, action) in returns:
                    returns[(state, action)] += G
                    visits[(state, action)] += 1
                else:
                    returns[(state, action)] = G
                    visits[(state, action)] = 1

                q_values[state] = np.zeros(env.action_space.n)
                q_values[state][action] = returns[(
                    state, action)] / visits[(state, action)]

    # Derive the optimal policy
    policy = {}
    for state in q_values:
        policy[state] = np.argmax(q_values[state])

    return policy


def test_agent(env, policy, episodes=10):
    """
    Test a learned policy in a given environment and compute the average rewards.

    Args:
    - env (gymnasium.Env): Gymnasium environment.
    - policy (dict): Policy to be tested.
    - episodes (int): Number of test episodes (default: 10).

    Returns:
    - float: Average reward obtained during test episodes.

    """
    rewards = []
    for _ in tqdm(range(episodes), desc="Episodes", unit="episode"):
        state, _ = env.reset()
        total_reward = 0
        done = False
        while not done:
            env.render()
            action = policy[state]
            state, reward, done, _, _ = env.step(action)
            total_reward += reward
        rewards.append(total_reward)

    avg_reward = np.mean(rewards)
    return avg_reward


def main():
    env = gym.make('FrozenLake-v1', is_slippery=True, render_mode='human')

    train_episodes = 300  # Number of training episodes
    test_episodes = 10    # Number of test episodes

    print('Training...')
    policy = monte_carlo_control(env, train_episodes)  # Train the agent

    print('Testing...')
    avg_reward = test_agent(env, policy, test_episodes)  # Evaluate the agent
    print('Average reward: ', avg_reward)


if __name__ == '__main__':
    main()
