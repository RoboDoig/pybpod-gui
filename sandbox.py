from pybpodapi.protocol import Bpod, StateMachine
import random

my_bpod = Bpod(serial_port='COM14')

nTrials = 5
trialTypes = [1, 2]

for i in range(nTrials):
    print('Trial: ', i+1)
    thisTrialType = random.choice(trialTypes)  # Randomly choose trial type

    sma = StateMachine(my_bpod)

    sma.add_state(
        state_name='WaitForLick',
        state_timer=0,
        state_change_conditions={Bpod.Events.Port1In: 'Reward'},
        output_actions=[]
    )

    sma.add_state(
        state_name='Reward',
        state_timer=0.1,
        state_change_conditions={Bpod.Events.Tup: 'Delay'},
        output_actions=[(Bpod.OutputChannels.Valve, 1)]
    )

    sma.add_state(
        state_name='Delay',
        state_timer=2,
        state_change_conditions={Bpod.Events.Tup: 'exit'},
        output_actions=[]
    )

    my_bpod.send_state_machine(sma)

    print("Waiting")

    my_bpod.run_state_machine(sma)

    print("Current trial info: ", my_bpod.session.current_trial)

my_bpod.close()
