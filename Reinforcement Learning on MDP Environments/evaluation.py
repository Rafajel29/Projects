# Heejin Chloe Jeong

import numpy as np

def get_action_egreedy(values ,epsilon):

    greedy = np.random.rand()
    
    if greedy > epsilon:
        a = np.argmax(values)
    else:
        a = np.random.randint(4)
    
    return a


def evaluation(env, Q_table, step_bound = 100, num_itr = 10):
    total_step = 0 
    total_reward = 0 
    itr = 0 
    while(itr<num_itr):
        step = 0
        np.random.seed()
        state = env.reset()
        reward = 0.0
        done = False
        while((not done) and (step < step_bound)):
            action = get_action_egreedy(Q_table[state], 0.05)
            r, state_n, done = env.step(state,action)
            state = state_n
            reward += r
            step +=1
        total_reward += reward
        total_step += step
        itr += 1
        return total_step/float(num_itr), total_reward/float(num_itr)
