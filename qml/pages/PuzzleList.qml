import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."


Page {
	id: puzzleList

	allowedOrientations: Orientation.All

	property bool visibleDescs
	property real iconSize
	property int columns
	property int nameFontSize
	property int descFontSize

	visibleDescs: false
	iconSize: Theme.iconSizeLarge
	columns: { 
		var fits = Math.floor(width/(2*iconSize));
		if (visibleDescs)
			fits /= 2;
		return Math.max(1, Math.floor(fits));
	}
	nameFontSize: Theme.fontSizeMedium
	descFontSize: Theme.fontSizeTiny

	SilicaGridView {
		id: gridView
		anchors.fill: parent

		// double width/height with visible descs
		cellWidth: (width/puzzleList.columns)
		cellHeight: (iconSize + 2*nameFontSize)*(1 + visibleDescs)

		snapMode: GridView.SnapToRow

		// we want the header to wrap, and this requires accessing _titleItem
		// even though it's far from ideal 8-/
		header: PageHeader {
			title: "Simon Tatham's Portable Puzzles Collection"
			height: _titleItem.contentHeight
			_titleItem.wrapMode: Text.WordWrap
			_titleItem.horizontalAlignment: Text.AlignRight
		}

		PullDownMenu {
			MenuItem {
				text: puzzleList.visibleDescs ? "Hide descriptions" : "Show descriptions"
				onClicked: { puzzleList.visibleDescs = !puzzleList.visibleDescs }
			}
			MenuItem {
				text: "Load saved game …"
				onClicked: { console.error("loading saved games not implemented yet") }
			}
		}

		model: PuzzleListModel {
			source: "../../puzzles.xml"
		}

		delegate: BackgroundItem {
			id: bItem
			width: gridView.cellWidth
			height: gridView.cellHeight

			onClicked: {
				console.log(puzzle + " clicked");
			}

			onPressAndHold: {
				console.log(puzzle + " held");
			}

			// if descriptions are visible, place title + description next to the icon,
			// otherwise place just the title below the icon

			property string icon
			icon: "image://theme/icon-m-mouse"

			Column {
				anchors.fill: parent
				visible: !puzzleList.visibleDescs
				Image {
					id: puzzleIcon
					anchors.horizontalCenter: parent.horizontalCenter

					width: puzzleList.iconSize
					height: puzzleList.iconSize
					source: icon
				}

				Label {
					id: puzzleTitle

					anchors.horizontalCenter: parent.horizontalCenter

					font.family: Theme.fontFamily
					font.pixelSize: puzzleList.nameFontSize
					text: name
				}
			}

			Label {
				id: puzzleDesc
				width: bItem.width
				height: bItem.height
				visible: puzzleList.visibleDescs

				font.family: Theme.fontFamily
				font.pixelSize: puzzleList.descFontSize
				wrapMode: Text.WordWrap
				// TODO left-aligned icon. an img with style float:left doesn't
				// work particularly nice
				text: "<h1>" + name + "</h1>" +
					"<p>" + desc
			}
		}
	}
}


