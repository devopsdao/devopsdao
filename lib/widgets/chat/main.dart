// import 'package:file_picker/file_picker.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:nanoid/async.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/empty_classes.dart';
import '../../blockchain/classes.dart';
import '../../config/theme.dart';
import '../../task_dialog/model_view/task_update_model_view.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../../config/utils/my_tools.dart';
import '../wallet_action_dialog.dart';

// void main() {
//   initializeDateFormatting().then((_) => runApp(const MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) => const MaterialApp(
//     home: ChatPage(),
//   );
// }

class ChatWidget extends StatefulWidget {
  final EthereumAddress taskAddress;
  final TasksServices tasksServices;
  const ChatWidget(
      {super.key,
      required this.taskAddress,
      required this.tasksServices});
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  bool logged = false;

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    // TaskUpdateModelView taskUpdateModelView = context.watch<TaskUpdateModelView>();

    int dateInt = widget.tasksServices.tasks[widget.taskAddress]!.messages.last[2].toInt();
    DateTime taskLastMessageTimestamp = DateTime.fromMillisecondsSinceEpoch(dateInt * 1000);
    Duration duration = DateTime.now().difference(taskLastMessageTimestamp);
    if (duration.inSeconds < 15) {
      _loadMessages();
    }

    if (listenWalletAddress != null) {
      logged = true;
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
      final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
      final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
      final statusBarHeight = MediaQuery.of(context).viewPadding.top;
      return Chat(
        // disableKeyboardDetection: true,
        messages: _messages,
        customBottomWidget: !logged ? const NotLoggedInput() : null,
        // onAttachmentPressed: _handleAttachmentPressed,
        // onMessageTap: _handleMessageTap,
        // onPreviewDataFetched: _handlePreviewDataFetched,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        onSendPressed: _handleSendPressed,
        showUserAvatars: false,
        showUserNames: true,

        user: types.User(id: listenWalletAddress.toString()),
        inputOptions: const InputOptions(
            // sendButtonVisibilityMode: SendButtonVisibilityMode.editing,
            ),

        theme: DefaultChatTheme(
          // inputPadding: EdgeInsets.fromLTRB(24, 20, 24, 20),
          // inputMargin: EdgeInsets.fromLTRB(24, 20, 24, 20),
          backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
          inputBackgroundColor: Colors.black87,
          inputBorderRadius: DodaoTheme.of(context).borderRadius,
        ),
      );
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // void _handleAttachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) => SafeArea(
  //       child: SizedBox(
  //         height: 144,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 // _handleImageSelection();
  //               },
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Photo'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 // _handleFileSelection();
  //               },
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('File'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );
  //
  //     _addMessage(message);
  //   }
  // }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );
  //
  //   if (result != null) {
  //     final bytes = await result.readAsBytes();
  //     final image = await decodeImageFromList(bytes);
  //
  //     final message = types.ImageMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       height: image.height.toDouble(),
  //       id: const Uuid().v4(),
  //       name: result.name,
  //       size: bytes.length,
  //       uri: result.path,
  //       width: image.width.toDouble(),
  //     );
  //
  //     _addMessage(message);
  //   }
  // }

  // void _handleMessageTap(BuildContext _, types.Message message) async {
  //   if (message is types.FileMessage) {
  //     var localPath = message.uri;
  //
  //     if (message.uri.startsWith('http')) {
  //       try {
  //         final index =
  //             _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //             (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: true,
  //         );
  //
  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });
  //
  //         final client = http.Client();
  //         final request = await client.get(Uri.parse(message.uri));
  //         final bytes = request.bodyBytes;
  //         final documentsDir = (await getApplicationDocumentsDirectory()).path;
  //         localPath = '$documentsDir/${message.name}';
  //
  //         if (!File(localPath).existsSync()) {
  //           final file = File(localPath);
  //           await file.writeAsBytes(bytes);
  //         }
  //       } finally {
  //         final index =
  //             _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //             (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: null,
  //         );
  //
  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });
  //       }
  //     }
  //
  //     // await OpenFilex.open(localPath);
  //   }
  // }

  // void _handlePreviewDataFetched(
  //   types.TextMessage message,
  //   types.PreviewData previewData,
  // ) {
  //   final index = _messages.indexWhere((element) => element.id == message.id);
  //   final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
  //     previewData: previewData,
  //   );
  //
  //   setState(() {
  //     _messages[index] = updatedMessage;
  //   });
  // }

  void _handleSendPressed(types.PartialText message) async {
    final messageNanoID = await customAlphabet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-', 5);
    Task? task = widget.tasksServices.tasks[widget.taskAddress];
    widget.tasksServices.sendChatMessage(task!.taskAddress, task.nanoId, message.text, messageNanoID);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WalletActionDialog(
              nanoId: task.nanoId,
              actionName: 'sendChatMessage_$messageNanoID',
            ));

    final textMessage = types.TextMessage(
      author: types.User(
        firstName: shortAddressAsNickname(widget.tasksServices.publicAddress),
          lastName: '',
          id: widget.tasksServices.publicAddress.toString()
      ),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    // print(task.messages[0][3].toString());
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    Task? task = widget.tasksServices.tasks[widget.taskAddress];
    List taskMessages = [];
    String ownerNickName = shortAddressAsNickname(task!.contractOwner.toString());

    // Firs message:
    Map<String, dynamic> message = {};
    Map<String, dynamic> author = {};
    author['firstName'] = ownerNickName;
    // author['firstName'] = 'vaso';
    author['lastName'] = '';
    author['id'] = '1';
    // author['id'] = const Uuid().v4();
    message['author'] = author;
    message['createdAt'] = task.createTime.millisecondsSinceEpoch;
    message['id'] = "0";
    message['status'] = 'delivered';
    message['text'] = '[Task name] ${task.title}';
    message['type'] = 'text';
    // final String firstName = msg[3].toString();
    // taskMessages.add(message);
    // final textMessage = types.TextMessage(
    //   author: _user,
    //   createdAt: msg[2].toInt(),
    //   id: msg[0].toString(),
    //   text: msg[1],
    // );
    // _addMessage(textMessage);
    taskMessages.add(message);

    for (var msg in task.messages) {
      String authorNickName = shortAddressAsNickname(msg[3].toString());
      Map<String, dynamic> message = {};
      Map<String, dynamic> author = {};
      author['firstName'] =authorNickName;
      // author['firstName'] = 'vaso';
      author['lastName'] = '';
      author['id'] = msg[3].toString();
      // author['id'] = const Uuid().v4();
      message['author'] = author;
      message['createdAt'] = msg[2].toInt() * 1000;
      message['id'] = msg[0].toString();
      message['status'] = 'delivered';
      message['text'] = msg[1];
      message['type'] = 'text';
      // final String firstName = msg[3].toString();
      // taskMessages.add(message);
      // final textMessage = types.TextMessage(
      //   author: _user,
      //   createdAt: msg[2].toInt(),
      //   id: msg[0].toString(),
      //   text: msg[1],
      // );
      // _addMessage(textMessage);
      taskMessages.add(message);
    }
    // final String messagesJson = jsonEncode(taskMessages);

    // {
    //   "author": {
    //     "firstName": "Rod",
    //     "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
    //     "lastName": ""
    //   },
    //   "createdAt": 1666556296000,
    //   "id": "4e048753-2d60-4144-bc28-9967050aaf12",
    //   "status": "seen",
    //   "text": "Wow you made it!",
    //   "type": "text"
    // },

    // final response = await rootBundle.loadString('assets/messages.json');
    // final origMessages = jsonDecode(response);
    // final messages = (jsonDecode(messagesJson) as List)
    final messages = (taskMessages.reversed)
        // final messages = (taskMessages)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }
}

class NotLoggedInput extends StatefulWidget {
  const NotLoggedInput({Key? key}) : super(key: key);

  @override
  _NotLoggedInputState createState() => _NotLoggedInputState();
}

class _NotLoggedInputState extends State<NotLoggedInput> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    setState(() {});

    return Material(
      elevation: 0,
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        // height: MediaQuery.of(context).size.width * .08,
        // width: MediaQuery.of(context).size.width * .57
        // width: innerPaddingWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          children: <Widget>[
            Text(
              'Please connect your wallet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
