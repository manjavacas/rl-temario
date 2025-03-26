import torch
import torch.nn as nn
import torch.nn.functional as F

import numpy as np

from tqdm.auto import trange


class ActorCriticNetwork(nn.Module):
    """
    Red neuronal unificado para ACTOR y CRITICO:
      - Actor: estima la política (distribución sobre acciones).
      - Crítico: estima el valor del estado.
    """

    def __init__(self, state_dim, action_dim, hidden_size=64):
        super().__init__()
        self.fc1 = nn.Linear(state_dim, hidden_size)
        # Actor: devuelve la distribución sobre las acciones
        self.fc_policy = nn.Linear(hidden_size, action_dim)
        # Crítico: devuelve un valor escalar
        self.fc_value = nn.Linear(hidden_size, 1)

    def forward(self, state):
        x = F.relu(self.fc1(state))
        action_probs = F.softmax(self.fc_policy(x), dim=-1)
        value = self.fc_value(x)
        return action_probs, value


class ActorCriticAgent():
    """
    Agente Actor-Critic para espacios de acción discretos.
    """

    def __init__(self, env, model_file=None):
        self.env = env
        self.actor_critic_net = None
        self.device = torch.device(
            'cuda' if torch.cuda.is_available() else 'cpu')
        if model_file:
            self.actor_critic_net = torch.load(
                model_file, map_location=self.device)

    def predict(self, obs):
        """
        Dada una observación, devuelve:
         - La acción seleccionada.
         - La log-probabilidad de dicha acción.
         - La estimación del valor del estado.
        """
        obs_tensor = torch.tensor(obs, dtype=torch.float32).to(self.device)
        policy, value = self.actor_critic_net(obs_tensor)
        dist = torch.distributions.Categorical(policy)
        action = dist.sample()
        log_prob = dist.log_prob(action)
        return action.item(), log_prob, value

    def train(self, alpha=1e-3, gamma=.99, train_episodes=5_000, save_filename='model_actor_critic.pth', show_rewards=False):
        """
        Entrenamiento mediante 1-step Actor-Critic (discreto).
        """
        self.actor_critic_net = ActorCriticNetwork(
            self.env.observation_space.shape[0], self.env.action_space.n
        ).to(self.device)

        optimizer = torch.optim.Adam(
            self.actor_critic_net.parameters(), lr=alpha)
        cum_rewards_per_episode = []

        for _ in trange(train_episodes):
            obs, _ = self.env.reset()
            done = False
            cum_reward = 0

            while not done:
                obs_tensor = torch.tensor(
                    obs, dtype=torch.float32).to(self.device)
                action_probs, value = self.actor_critic_net(obs_tensor)

                # Obtener accion y log_prob de distribución categórica
                dist = torch.distributions.Categorical(action_probs)
                action = dist.sample()
                log_prob = dist.log_prob(action)

                # Ejecutar la acción en el entorno
                next_obs, reward, terminated, truncated, _ = self.env.step(
                    action.item())
                done = terminated or truncated
                cum_reward += reward

                # Calcular el valor del siguiente estado (0 si es terminal)
                if done:
                    next_value = 0.0
                else:
                    next_obs_tensor = torch.tensor(
                        next_obs, dtype=torch.float32).to(self.device)
                    with torch.no_grad():
                        next_value = self.actor_critic_net(
                            next_obs_tensor)[1]
                    next_value = next_value.detach()

                # Calcular target y delta (error)
                target = reward + gamma * next_value
                delta = target - value

                # Loss de actor y crítico
                actor_loss = -log_prob * delta.detach()
                critic_loss = delta.pow(2)
                loss = actor_loss + critic_loss

                # Actualizar política
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                obs = next_obs

            cum_rewards_per_episode.append(cum_reward)

        self.env.close()
        torch.save(self.actor_critic_net, save_filename)

        if show_rewards:
            import matplotlib.pyplot as plt
            plt.plot(cum_rewards_per_episode)
            plt.xlabel('Episodio')
            plt.ylabel('Recompensa acumulada')
            plt.savefig('recompensas_actor_critic.png')

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
                action, _, _ = self.predict(obs)
                obs, reward, terminated, truncated, _ = test_env.step(action)
                done = terminated or truncated
                rewards.append(reward)
            print(f'Recompensa total = {np.sum(rewards)}')
        test_env.close()
