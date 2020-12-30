import 'dart:io';
import 'package:Siuu/custom/customCameraWidget.dart';
import 'package:Siuu/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/services/media/models/media_file.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OBCameraPickerBottomSheet extends StatelessWidget {
  const OBCameraPickerBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);

    LocalizationService localizationService = provider.localizationService;
    ModalService _modalService = provider.modalService;

    List<Widget> cameraPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: OBText(
          localizationService.post__create_photo,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            File file;
            //File file = await ImagePicker.pickImage(source: ImageSource.camera);
            _modalService.openCameraWidget(context: context);
            /*Navigator.pop(
                context, file != null ? MediaFile(file, FileType.image) : null);*/
          }
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.video_camera),
        title: OBText(
          localizationService.post__create_video,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            File file = await ImagePicker.pickVideo(source: ImageSource.camera);
            Navigator.pop(
                context, file != null ? MediaFile(file, FileType.video) : null);
          }
        },
      ),
    ];

    return OBRoundedBottomSheet(
        child: Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        children: cameraPickerActions,
        mainAxisSize: MainAxisSize.min,
      ),
    ));
  }
}
