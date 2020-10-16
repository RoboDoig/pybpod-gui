from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QVariant, QTimer, QThread, QUrl
from PyQt5.QtQml import QQmlComponent
from PyQt5.QtQuick import QQuickItem


class Interface(QObject):
    def __init__(self, app, context, parent, engine):
        QObject.__init__(self, parent)
        self.app = app
        self.ctx = context
        self.win = parent
        self.engine = engine

        self.state_model = StateModel()

    @pyqtSlot(QVariant)
    def on_released(self, obj):
        print(obj.property('x'), obj.property('y'))

    @pyqtSlot(QVariant)
    def create_new(self, obj):
        self.state_model.update_states(obj.toVariant())

    @pyqtSlot(QVariant)
    def printer(self, obj):
        print(obj)


class StateModel:
    def __init__(self):
        self.states = dict()

    def update_states(self, states_obj):
        print(states_obj['0'])
