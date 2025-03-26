import torch
import torch.nn as nn
import torch.nn.functional as F

import numpy as np
import matplotlib.pyplot as plt

from tqdm.auto import trange


class PolicyNetwork(nn.Module):
    """
    Red neuronal para aproximar la política.
    """

    def __init__(self, state_dim, action_dim, hidden_size=64):
        """
        Inicializacion de la red neuronal.
        """
        super().__init__()

        self.fc1 = nn.Linear(state_dim, hidden_size)
        self.fc2 = nn.Linear(hidden_size, action_dim)

    def forward(self, state):
        """
        Devuelve la probabilidad de cada accion (softmax).
        """
        x = F.relu(self.fc1(state))
        return F.softmax(self.fc2(x), dim=-1)


class ReinforceAgent():
    '''
    Implementación de REINFORCE para espacios de acciones discretos.
    '''

    def __init__(self, env, model_file=None):
        '''
        Constructor.
        '''
        self.env = env
        self.policy_net = None
        self.device = torch.device(
            'cuda' if torch.cuda.is_available() else 'cpu')

        if model_file:
            self.policy_net = torch.load(model_file, map_location=self.device)

    def predict(self, obs):
        '''
        Dada una observación, devuelve:
         - La acción seleccionada.
         - La log-probabilidad de dicha acción.
        '''
        state_tensor = torch.tensor(obs, dtype=torch.float32).to(self.device)
        action_probs = self.policy_net(state_tensor)

        dist = torch.distributions.Categorical(action_probs)
        action = dist.sample()
        log_prob = dist.log_prob(action)

        return action.item(), log_prob

    def train(self, alpha=1e-3, gamma=.99, train_episodes=1_000, save_filename='model_REINFORCE.pth', show_rewards=False):
        '''
        Entrenamiento de la política mediante REINFORCE.
        '''
        self.policy_net = PolicyNetwork(
            self.env.observation_space.shape[0], self.env.action_space.n).to(self.device)

        optimizer = torch.optim.Adam(self.policy_net.parameters(), lr=alpha)
        cum_rewards_per_episode = []

        for _ in trange(train_episodes):

            obs, _ = self.env.reset()
            done = False
            rewards = []
            log_probs = []

            # Realizar trayectoria
            while not done:
                action, log_prob = self.predict(obs)
                obs, reward, terminated, truncated, _ = self.env.step(action)
                done = terminated or truncated
                rewards.append(reward)
                log_probs.append(log_prob)

            # Calcular retornos acumulados (G) para cada paso
            returns = []
            G = 0
            for reward in reversed(rewards):
                G = reward + gamma * G
                returns.append(G)
                
            returns = returns[::-1]
            returns = torch.tensor(returns, dtype=torch.float32).to(self.device)

            # Calcular pérdida (minimizar perdida --> maximizar la recompensa esperada)
            loss = -sum(log_prob * G for log_prob,
                        G in zip(log_probs, returns))

            # Actualizar política
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            # Calcular la recompensa media para este episodio
            cum_reward = np.sum(rewards)
            cum_rewards_per_episode.append(cum_reward)

        self.env.close()
        torch.save(self.policy_net, save_filename)

        if show_rewards:
            plt.plot(cum_rewards_per_episode)
            plt.xlabel('Episodio')
            plt.ylabel('Recompensa media')
            plt.savefig('recompensas_REINFORCE.png')

        return cum_rewards_per_episode

    def test(self, test_env=None, n_episodes=1):
        """
        Evaluar agente.
        """
        for _ in range(n_episodes):
            obs, _ = test_env.reset()
            done = False
            rewards = []
            while not done:
                test_env.render()
                action, _ = self.predict(obs)
                obs, reward, terminated, truncated, _ = test_env.step(action)
                done = terminated or truncated
                rewards.append(reward)

            print(f'Recompensa media = {np.mean(rewards)}')
        test_env.close()
