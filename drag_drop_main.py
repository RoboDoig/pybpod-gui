import sys

from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
from PyQt5.QtCore import QUrl

from drag_drop_interface import Interface


if __name__ == '__main__':
    app = QApplication(sys.argv)

    appEngine = QQmlApplicationEngine()

    context = appEngine.rootContext()

    appEngine.load(QUrl('drag-drop.qml'))

    root = appEngine.rootObjects()[0]

    # Register Python classes with qml
    interface = Interface(app, context, root, appEngine)

    context.setContextProperty('iface', interface)

    root.show()
    try:
        apcode = app.exec_()
    except:
        print('there was an issue')
    finally:
        sys.exit(apcode)

