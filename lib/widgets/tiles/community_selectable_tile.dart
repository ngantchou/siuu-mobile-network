import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/checkbox.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';

class OBMemorySelectableTile extends StatelessWidget {
  final Memory memory;
  final ValueChanged<Memory> onMemoryPressed;
  final bool isSelected;

  const OBMemorySelectableTile(
      {Key key,
      @required this.memory,
      @required this.onMemoryPressed,
      @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onMemoryPressed(memory);
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: OBMemoryTile(
              memory,
              size: OBMemoryTileSize.small,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: OBCheckbox(
              value: isSelected,
            ),
          )
        ],
      ),
    );
  }
}
