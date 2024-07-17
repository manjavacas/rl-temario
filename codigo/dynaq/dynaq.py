import numpy as np
import random


class DynaQ:
    '''
    DynaQ agent class.
    '''

    def __init__(self, alpha=1, gamma=.95, epsilon=.1, plan_steps=5):

        self.q_table = {}
        self.model = {}

        self.actions = ['up', 'down', 'left', 'right']

        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon

    def __e_greedy(self, state):
        '''
        Selects an action using epsilon-greedy policy.

        Parameters:
            state (tuple): Current state.

        Returns:
            action (str): Chosen action.
        '''

        if np.random.uniform(0, 1) < self.epsilon:
            return np.random.choice(self.actions)
        else:
            state_actions = self.q_table[state]
            max_value = max(state_actions.values())
            max_actions = [action for action,
                           value in state_actions.items() if value == max_value]
            return np.random.choice(max_actions)

    def learn(self, env, n_episodes=50, plan_steps=5, verbose=True):
        '''
        Learning method.

        Parameters:
            env: Environment object with methods `step` and attributes `start_pos`.
            n_episodes (int): Number of episodes for training.
            plan_steps (int): Number of planning steps.
            verbose (bool): Whether to show episodic rewards.
        '''

        ########################## DynaQ algorithm ##########################

        # Initialize Q(s,a) and Model(s,a) for each s € Ss, a € As

        # loop forever:

        # a) S <- current non terminal state
        # b) A <- e-greedy(S,Q)
        # c) take action A, observe R and S'
        # d) Q(S,A) <- Q(S,A) + alpha [R + gamma max_a Q(S',a) - Q(S,A)]
        # e) Model(S,A) <- R, S' (deterministic env)
        # f) loop N times:
        #       S <- random previously observed state
        #       A <- random action previously taken in S
        #       R,S' <- Model(S,A)
        #       Q(S,A) <- Q(S,A) + alpha [R + gamma max_a Q(S',a) - Q(S,A)]

        #####################################################################

        self.q_table = {}
        self.model = {}

        ep_rewards = []

        for episode in range(n_episodes):

            total_reward = 0
            s = env.start_pos

            while True:

                # Register state in Q-table
                if s not in self.q_table:
                    self.q_table[s] = {action: 0 for action in self.actions}

                # E-greedy action selection
                a = self.__e_greedy(s)

                # Perform action. Observe s', r and end condition
                s_next, r, end = env.step(s, a)
                total_reward += r

                # Register next state in Q-table
                if s_next not in self.q_table:
                    self.q_table[s_next] = {
                        action: 0 for action in self.actions}

                # Q-learning update
                td_target = r + self.gamma * max(self.q_table[s_next].values())
                td_error = td_target - self.q_table[s][a]
                self.q_table[s][a] += self.alpha * td_error

                # Update Model
                if s not in self.model:
                    self.model[s] = {}
                self.model[s][a] = (s_next, r)

                # Planning
                for _ in range(plan_steps):
                    sim_s = random.choice(list(self.model.keys()))
                    sim_a = random.choice(list(self.model[sim_s].keys()))

                    sim_s_next, sim_r = self.model[sim_s][sim_a]

                    sim_td_target = sim_r + self.gamma * \
                        max(self.q_table[sim_s_next].values())
                    sim_td_error = sim_td_target - self.q_table[sim_s][sim_a]
                    self.q_table[sim_s][sim_a] += self.alpha * sim_td_error

                s = s_next

                if end:
                    break

            ep_rewards.append(total_reward)

            if verbose:
                print(
                    f"Episode {episode + 1}/{n_episodes}, Total Reward: {total_reward}")

        return ep_rewards
