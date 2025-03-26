import gymnasium as gym

from reinforce import ReinforceAgent
from actor_critic import ActorCriticAgent
from actor_critic_continuous import ActorCriticContinuousAgent

env = gym.make('CartPole-v1')
test_env = gym.make('CartPole-v1', render_mode='human')

# --------- REINFORCE ---------#
reinforce_agent = ReinforceAgent(env)
reinforce_agent.train(train_episodes=1_000, show_rewards=True)
reinforce_agent.test(test_env, 1)

# -------- ACTOR CRITIC (discreto) --------#
ac_agent = ActorCriticAgent(env)
ac_agent.train(train_episodes=1_000, show_rewards=True)
ac_agent.test(test_env, 1)

# -------- ACTOR CRITIC (continuo) --------#
env = gym.make('Pendulum-v1')
test_env = gym.make('Pendulum-v1', render_mode='human')

ac_agent_cont = ActorCriticContinuousAgent(env)
ac_agent_cont.train(train_episodes=1_000, show_rewards=True)
ac_agent_cont.test(test_env, 1)
