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
        state_name, state_id = self.state_model.create_state()
        print(state_name, state_id)

        # tell the GUI to initialize this state
        self.root.stateCreated(state_name, state_id)
        print("create new state")

    @pyqtSlot(QVariant)
    def printer(self, obj):
        print(obj)


class StateModel:
    def __init__(self):
        self.states = dict()
        self.state_id_counter = 0

    def create_state(self):
        state_name = 'state' + str(self.state_id_counter)
        state_id = self.state_id_counter

        self.states[state_id] = State(state_name, state_id)
        self.state_id_counter += 1

        return state_name, state_id

    def update_states(self, states_obj):
        print(states_obj['0'])


class State:
    def __init__(self, name, id):
        self.name = name
        self.id = id
        self.transitions = list()
