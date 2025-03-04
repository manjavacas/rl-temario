import random

import numpy as np

import torch
import torch.nn as nn
import torch.optim as optim

from tqdm import trange

import gymnasium as gym


class QNetwork(nn.Module):
    """
    Red neuronal para aproximar la función Q(s,a)

    - Input: vector de observaciones y valor de acción (un único valor)
    - Output: valor estimado (Q(s,a))
    """

    def __init__(self, state_dim, action_dim=1, hidden_size=128):
        """
        Inicialización de la red neuronal
        """
        super().__init__()

        self.fc1 = nn.Linear(state_dim + action_dim, hidden_size)
        self.relu1 = nn.ReLU()

        self.fc2 = nn.Linear(hidden_size, hidden_size)
        self.relu2 = nn.ReLU()

        self.fc3 = nn.Linear(hidden_size, 1)

    def forward(self, state, action):
        """
        Predicción del Q-value a partir del estado y la acción
        """
        x = torch.cat((state, action), dim=0)

        x = self.fc1(x)
        x = self.relu1(x)
        x = self.fc2(x)
        x = self.relu2(x)

        q_value = self.fc3(x)
        return q_value


class SemiGradientSARSA():
    """
    Agente basado en Semi-Gradient SARSA para estimar Q(s,a)
    """

    def __init__(self, env_name, model_file=None):
        """
        Constructor
        """
        self.env_name = env_name
        self.env = gym.make(self.env_name, render_mode='rgb_array')

        self.q_net = None
        self.device = torch.device(
            'cuda' if torch.cuda.is_available() else 'cpu')

        if model_file:
            self.q_net = torch.load(model_file, map_location=self.device)
            self.q_net.eval()

    def fit(self, n_episodes, alpha=1e-4, gamma=0.99, init_eps=0.99, eps_decay=0.01, min_eps=0.1, save_filename='model.pth'):
        """
        Estimación de la función Q(s,a) mediante Semi-Gradient SARSA
        """
        state_dim = self.env.observation_space.shape[0]
        self.q_net = QNetwork(state_dim).to(self.device)

        optimizer = optim.Adam(self.q_net.parameters(), lr=alpha)
        criterion = nn.MSELoss()

        epsilon = init_eps

        for episode in trange(n_episodes):
            obs, _ = self.env.reset()
            done = False

            episode_losses = []
            episode_cumulative_reward = 0

            epsilon = max(epsilon, min_eps)

            action = self._e_greedy(state=obs, epsilon=epsilon)

            while not done:
                next_obs, reward, terminated, truncated, _ = self.env.step(
                    action)
                done = terminated or truncated

                episode_cumulative_reward += reward

                # Calcular TD-target: reward + gamma * Q(next_obs, next_action)
                if not done:
                    next_action = self._e_greedy(
                        state=next_obs, epsilon=epsilon)
                    next_state_tensor = torch.tensor(
                        next_obs, dtype=torch.float32).to(self.device)
                    next_action_tensor = torch.tensor(
                        [next_action], dtype=torch.float32).to(self.device)
                    with torch.no_grad():
                        q_next = self.q_net(
                            next_state_tensor, next_action_tensor)
                    target = reward + gamma * q_next.item()
                else:
                    target = reward

                # Actualizar la funcion de valor
                state_tensor = torch.tensor(
                    obs, dtype=torch.float32).to(self.device)
                action_tensor = torch.tensor(
                    [action], dtype=torch.float32).to(self.device)
                target_tensor = torch.tensor(
                    [target], dtype=torch.float32).to(self.device)

                q_value_pred = self.q_net(state_tensor, action_tensor)
                loss = criterion(q_value_pred, target_tensor)

                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                episode_losses.append(loss.item())

                obs = next_obs
                if not done:
                    action = next_action

            epsilon *= (1 - eps_decay)
            mean_loss = np.mean(episode_losses) if episode_losses else 0.0
            print(
                f'Ep. {episode+1}/{n_episodes} - Mean loss = {mean_loss:.6f}, Cumulative reward = {episode_cumulative_reward:.6f}')

        torch.save(self.q_net, save_filename)

    def _e_greedy(self, state, epsilon=0.1):
        """
        Selección de acción mediante política e-greedy
        """
        if random.random() < epsilon:
            action = self.env.action_space.sample()
        else:
            state_tensor = torch.tensor(
                state, dtype=torch.float32).to(self.device)
            q_values = []
            for a in range(self.env.action_space.n):
                action_tensor = torch.tensor(
                    [a], dtype=torch.float32).to(self.device)
                q_values.append(self.q_net(state_tensor, action_tensor).item())
            action = int(np.argmax(q_values))
        return action

    def act(self, state, deterministic=True, eps=0.1):
        """
        Selección de acción (determinista por defecto)
        """
        if deterministic:
            eps = 0
        return self._e_greedy(state, eps)

    def test(self, n_episodes=1):
        """
        Evaluar agente
        """
        test_env = gym.make(self.env_name, render_mode='human')

        obs, _ = test_env.reset()
        done = False
        rewards = []

        for _ in range(n_episodes):
            while not done:
                test_env.render()
                action = self.act(obs)
                obs, reward, terminated, truncated, _ = test_env.step(action)
                done = terminated or truncated
                rewards.append(reward)

            print(f'Recompensa media = {np.mean(rewards)}')
        test_env.close()


sarsa_agent = SemiGradientSARSA('CartPole-v1')
sarsa_agent.fit(n_episodes=2_000, save_filename='sarsa_agent.pth')
sarsa_agent.test()
