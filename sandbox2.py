state_dict = {'1': 'state1', '2': 'state2'}

n = 'state2'

for state in state_dict.keys():
    if state_dict[state] == n:
        print(state)