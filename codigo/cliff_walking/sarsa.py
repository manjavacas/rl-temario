import numpy as np
import matplotlib.pyplot as plt

from cliff_env import CliffWalk


class SARSA:
    '''
    SARSA agent class
    '''

    def __init__(self, env, alpha=.1, gamma=1, epsilon=.1):
        '''
        Class constructor
        '''
        self.env = env

        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon

        self.actions = ['up', 'down', 'left', 'right']

        self.q_table = {
            (x, y): {action: 0 for action in self.actions}
            for x in range(self.env.height) for y in range(self.env.width)
        }

        self.total_rewards = []

        # Uncomment for TD errors evolution
        # self.mean_td_errors = []
        # self.mean_td_error = 0
        # self.n = 1

    def get_action(self, state):
        '''
        Returns a sampled action according to E-greedy policy
        '''
        if np.random.uniform(0, 1) < self.epsilon:
            return np.random.choice(self.actions)
        else:
            x, y = state
            state_actions = self.q_table[(x, y)]
            max_value = max(state_actions.values())
            max_actions = [action for action,
                           value in state_actions.items() if value == max_value]
            return np.random.choice(max_actions)

    def update_q_value(self, s, a, r, s_next, a_next):
        '''
        Applies the SARSA update rule for state-action values
        '''
        td_target = r + self.gamma * self.q_table[s_next][a_next]
        td_error = td_target - self.q_table[s][a]
        self.q_table[s][a] += self.alpha * td_error

        # Uncomment for TD errors evolution
        # self.mean_td_error += td_error / self.n
        # self.n  += 1
        # self.mean_td_errors.append(self.mean_td_error)

    def learn(self, n_episodes, plot=True):
        '''
        Learn Q values by interaction
        '''

        for _ in range(n_episodes):

            total_reward = 0

            s = (0, 0)
            a = self.get_action(s)

            while not self.env.is_terminal(s):
                s_next, reward = self.env.get_transition(s, a)
                a_next = self.get_action(s_next)

                self.update_q_value(s, a, reward, s_next, a_next)

                s = s_next
                a = a_next

                total_reward += reward

            self.total_rewards.append(total_reward)

        print('Best SARSA episode reward = ', max(self.total_rewards))

        if plot:
            self.__plot_rewards_evolution()

        # Uncomment for TD errors evolution
        # self.__plot_evolution(self.mean_td_errors)

    def __plot_rewards_evolution(self):
        '''
        Plots the rewards evolution per episode
        '''
        plt.plot(self.total_rewards)
        plt.xlabel('Episode')
        plt.ylabel('Total Reward')
        plt.title('SARSA reward evolution')

        plt.show()


# env = CliffWalk()
# agent = SARSA(env)

# n_episodes = 500
# agent.learn(n_episodes)
