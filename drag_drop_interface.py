from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QVariant, QTimer, QThread, QUrl
from PyQt5.QtQml import QQmlComponent
from PyQt5.QtQuick import QQuickItem


class Interface(QObject):
    def __init__(self, app, context, root, engine):
        QObject.__init__(self, root)
        self.app = app
        self.ctx = context
        self.root = root
        self.engine = engine

        self.state_model = StateModel()

    @pyqtSlot(QVariant)
    def on_released(self, obj):
        print(obj.property('x'), obj.property('y'))

    @pyqtSlot()
    def create_new_state(self):
        # create a new state in the model
        state_name, state_timer, state_id = self.state_model.create_state()
        print(state_name, state_id)

        # tell the GUI to initialize this state
        self.root.stateCreated(state_name, state_timer, state_id)

    @pyqtSlot(int, str, float)
    def update_state(self, state_id, state_name, state_timer):
        self.state_model.update_state(state_id, state_name, state_timer)

    @pyqtSlot(int)
    def state_selected(self, state_id):
        self.show_transitions(state_id)

    @pyqtSlot(int)
    def add_transition(self, state_id):
        # give this state a new transition
        self.state_model.add_transition(state_id)

        # tell the GUI to show the transition for this state
        self.show_transitions(state_id)

    @pyqtSlot(str, str, int, int)
    def update_transition(self, condition, state, transition_idx, state_idx):
        self.state_model.states[state_idx].transitions[transition_idx] = (condition, state)

    @pyqtSlot(int, int)
    def remove_transition(self, transition_idx, state_idx):
        self.state_model.states[state_idx].transitions.pop(transition_idx)
        self.show_transitions(state_idx)

    def show_transitions(self, state_id):
        self.root.clearTransitions()
        for t, transition in enumerate(self.state_model.states[state_id].transitions):
            self.root.addTransition(transition[0], transition[1], t)

    @pyqtSlot(QVariant)
    def printer(self, obj):
        print(obj)


class StateModel:
    def __init__(self):
        self.states = dict()
        self.state_id_counter = 0

    def create_state(self):
        state_name = 'state' + str(self.state_id_counter)
        state_timer = 1
        state_id = self.state_id_counter

        self.states[state_id] = State(state_name, state_timer, state_id)
        self.state_id_counter += 1

        return state_name, state_timer, state_id

    def update_state(self, state_id, state_name, state_timer):
        self.states[state_id].name = state_name
        self.states[state_id].timer = state_timer
        print(self.states[state_id])

    def add_transition(self, state_id):
        self.states[state_id].transitions.append(("Tup", "State"))
        print("state transition added to: " + str(state_id))


class State:
    def __init__(self, name, timer, id):
        self.name = name
        self.id = id
        self.timer = timer
        self.transitions = list()

    def __str__(self):
        return 'State: (' + str(self.id) + ') ' + str(self.name) + '. Timer: ' + str(self.timer)
