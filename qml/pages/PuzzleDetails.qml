import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	id: puzzleDetails
	allowedOrientations: Orientation.All

	property real iconSize
	property string puzzle
	property string name
	property string desc
	iconSize: Theme.iconSizeLarge
	property alias title: puzzleDetails.name

	SilicaFlickable {
		anchors.fill: parent

		Column {
			anchors.fill: parent
			PageHeader {
				title: puzzleDetails.title
			}

			Label {
				id: puzzleDesc
				anchors {
					left: parent.left
					right: parent.right
					leftMargin: Theme.paddingLarge
					rightMargin: Theme.paddingLarge
				}

				wrapMode: Text.WordWrap
				text: { desc.replace(/^<p>\n/,'<body>') }
				font.pixelSize: Theme.fontSizeSmall
				horizontalAlignment: Text.AlignJustify
			}
		}
	}
}
