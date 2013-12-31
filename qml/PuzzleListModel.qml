/* might depend on qt5-qtdeclarative-import-xmllistmodel being installed*/
import QtQuick.XmlListModel 2.0

XmlListModel {
	query: "/puzzles/puzzle"
	XmlRole { name: "puzzle"; query: "@id/string()" }
	XmlRole { name: "name"; query: "name/string()" }
	XmlRole { name: "desc"; query: "desc/string()" }
}

