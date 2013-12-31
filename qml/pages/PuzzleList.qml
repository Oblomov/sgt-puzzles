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

	visibleDescs: true
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

		cellWidth: (width/puzzleList.columns)
		// room for the puzzle name below only if no descs
		cellHeight: iconSize + 2*nameFontSize // *(1 - puzzleList.visibleDescs)

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
				pageStack.push(Qt.resolvedUrl("PuzzleDetails.qml"), {
						iconSize: puzzleList.iconSize,
						puzzle: puzzle,
						name: name,
						desc: desc
					})
			}

			// if descriptions are visible, place title + description next to the icon,
			// otherwise place just the title below the icon

			property string icon
			icon: "image://theme/icon-m-mouse"

			Column {
				anchors.fill: parent
				visible: !puzzleList.visibleDescs
				Image {
					anchors.horizontalCenter: parent.horizontalCenter

					width: puzzleList.iconSize
					height: puzzleList.iconSize
					source: icon
				}

				Label {
					anchors.horizontalCenter: parent.horizontalCenter

					font.family: Theme.fontFamily
					font.pixelSize: puzzleList.nameFontSize
					text: name
				}
			}

			Row {
				anchors.fill: parent
				visible: puzzleList.visibleDescs

				Image {
					width: puzzleList.iconSize
					height: puzzleList.iconSize
					source: icon
				}

				Column {
					width: parent.width - iconSize
					height: parent.height

					Label {
						id: puzzleName
						font.family: Theme.fontFamily
						font.pixelSize: puzzleList.nameFontSize
						text: name
					}

					Label {
						id: puzzleDesc
						visible: puzzleList.visibleDescs
						width: parent.width
						height: parent.height - puzzleName.contentHeight
						clip: true

						// stolen and adapted from Silica/Label
						Item {
							parent: puzzleDesc.parent
							x: puzzleDesc.x
							y: puzzleDesc.y
							OpacityRampEffect {
								sourceItem: puzzleDesc
								enabled: puzzleList.visibleDescs && sourceItem.contentHeight > sourceItem.height
								direction: OpacityRamp.TopToBottom
								offset: 0.3
								slope: 1.2
								width: sourceItem.width
								height: sourceItem.height
								anchors.fill: null
							}
						}


						font.family: Theme.fontFamily
						font.pixelSize: puzzleList.descFontSize
						wrapMode: Text.WordWrap
						// first paragraph only, cleaned. sometimes hard lines
						// are respected, sometimes they aren't, strange
						text: { desc.split(/<p>\n/)[1].replace(/\n/g,' ') }
					}
				}
			}
		}
	}
}


