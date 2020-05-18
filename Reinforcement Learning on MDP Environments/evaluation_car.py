# Heejin Chloe Jeong

import numpy as np

def get_action_egreedy(values ,epsilon, num_actions):

    greedy = np.random.rand()
    
    if greedy > epsilon:
        a = np.argmax(values)
    else:
        a = np.random.randint(num_actions)
    
    return a


def evaluation(env, Q_table, num_actions, dimension, step_bound = 100, num_itr = 10):
    total_step = 0 
    total_reward = 0 
    itr = 0 
    while(itr<num_itr):
        step = 0
        np.random.seed()
        state = env.reset()
        state = deter_state(state,dimension)
        reward = 0.0
        done = False
        while((not done) and (step < step_bound)):
            action = get_action_egreedy(Q_table[state[0],state[1],:], 0.05, num_actions)
            deter, r, done, temp = env.step(action)
            state_n = deter_state(deter,dimension)
            state = state_n
            reward += r
            step +=1
        total_reward += reward
        total_step += step
        itr += 1
    return total_step/float(num_itr), total_reward/float(num_itr)


def deter_state(deter,dimension):
    length = len(dimension)
    states = np.zeros((length)).astype(np.int)
    for j in range(length):
        i = 0
        while True:
            if deter[j] > dimension[j,i]:
                i += 1
            else:
                states[j]=i
                break
    return states