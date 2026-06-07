import 'dart:developer' as d;
import 'dart:js_interop';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/features/chats/data/data_sources/chat_data_source.dart';
import 'package:hackathon/features/chats/data/data_sources/message_data_source.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/data/models/message_model.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/features/chats/domain/repositories/message_repository.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/features/chats/presentation/blocs/chat_bloc/chat_bloc_bloc.dart';
import 'package:hackathon/features/chats/presentation/blocs/message_bloc/message_bloc.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/features/chats/presentation/widgets/chat_bubble.dart';
import 'package:hackathon/features/chats/presentation/widgets/chat_tiles.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/widgets/custom_drawer.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';
import 'package:in_app_notification/in_app_notification.dart';

final _chatPageKey = GlobalKey<ScaffoldState>();

class ChatPage extends StatefulWidget {
  static const routePath = "/chats";
  final ChatEntity? initialChat;
  const ChatPage({super.key, this.initialChat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isChatSelected = false;
  String selectedChatName = "";
  ChatEntity? selectedChat;
  late Stream<List<ChatModel>> chatStream;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    chatStream = getIt<ChatDataSource>().getChats();
    if (widget.initialChat != null) {
      isChatSelected = true;
      selectedChat = widget.initialChat;
      selectedChatName = widget.initialChat!.isGroup
          ? (widget.initialChat!.name ?? "Group Chat")
          : (widget.initialChat!.participants.isNotEmpty
              ? "${widget.initialChat!.participants.first.firstName ?? ''} ${widget.initialChat!.participants.first.lastName ?? ''}".trim()
              : "Unknown User");
      getIt<MessageRepository>().fetchInitialMessages(widget.initialChat!.roomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.sizeOf(context).height;
    final swidth = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
          color: ColorPallete.backgroundPrimary),
      child: Scaffold(
        drawer: CustomDrawer(
          selectedIndex: ListOfSideBar.sideBarItems.indexOf('Chat'),
        ),
        key: _chatPageKey,
        backgroundColor: ColorPallete.transparent,
        body: ListView(
          children: [
            _customChatBar(),
            SizedBox(
              height: sheight * 00.01,
            ),
            Row(
              children: [
                StreamBuilder<List<ChatModel>>(
                  stream: chatStream,
                  builder: (BuildContext context, AsyncSnapshot<List<ChatModel>> snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          width: swidth * 0.25,
                          height: sheight * 0.87,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }

                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final state = snapshot.data!;

                      final List<ChatModel> chats = List<ChatModel>.from(state);
                      debugPrint(chats.toString());
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: ColorPallete.backgroundSecondary,
                            borderRadius: BorderRadius.circular(5)),
                        height: sheight * 0.87,
                        width: swidth * 0.25,
                        child: ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              debugPrint(
                                chats[index].id.toString(),
                              );
                              // d.debugPrint(getIt<User>().user.id.toString(), );
                              return GestureDetector(
                                onTap: () {
                                  if (selectedChat?.id == chats[index].id) {
                                    setState(() {
                                      isChatSelected = false;
                                      selectedChatName = "";
                                      selectedChat = null;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    isChatSelected = true;
                                    selectedChatName = chats[index].isGroup
                                        ? (chats[index].name ?? "Group Chat")
                                        : (chats[index].participants.isNotEmpty
                                            ? "${chats[index].participants.first.firstName ?? ''} ${chats[index].participants.first.lastName ?? ''}".trim()
                                            : "Unknown User");
                                    selectedChat = chats[index];
                                  });
                                  getIt<MessageRepository>().fetchInitialMessages(chats[index].roomId);
                                },
                                child: ChatTiles(
                                  chatEntity: chats[index],
                                ),
                              );
                            }),
                      );
                    } else {
                      return Text(snapshot.connectionState.toString());
                    }
                  },
                ),
                if (!isChatSelected)
                  SizedBox(
                    width: swidth * 0.2,
                  ),
                Visibility(
                  visible: !isChatSelected,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ImageAssets.chat),
                      const Text(
                          "“contacting others for help can make you more productive”")
                    ],
                  ),
                ),
                Visibility(
                    visible: isChatSelected,
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: ColorPallete.backgroundTertiary,
                            borderRadius: BorderRadius.circular(10)),
                        height: sheight * 0.87,
                        // width: swidth * 0.8,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: CustomAppBar(children: [
                                const Icon(
                                  Icons.person,
                                ),
                                Text(selectedChatName),
                                const Spacer(),
                                GestureDetector(
                                  child: const Icon(Icons.call),
                                  onTap: () {
                                    context.push(CallPage.routePath, extra: {
                                      "isCalling": true,
                                      'chat': selectedChat
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: swidth * 0.02,
                                )
                              ]),
                            ),
                            if (isChatSelected)
                              BlocListener<MessageBloc, MessageState>(
                                listener: (context, state) {
                                  if (state is MessageErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                state.errorModel.message)));
                                  }
                                },
                                child: Expanded(
                                    child: StreamBuilder<List<MessageEntity>>(
                                  stream: getIt<MessageRepository>()
                                      .getMessages(selectedChat!.roomId),
                                  builder: ((BuildContext context,
                                      AsyncSnapshot<List<MessageEntity>> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final List<MessageEntity> data = List<MessageEntity>.from(snapshot.data!);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _scrollController.jumpTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                        );
                                      });
                                      return ListView.builder(
                                        controller: _scrollController,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return ChatBubble(
                                              chatMessageEntity: data[index]);
                                        },
                                      );
                                    }
                                    return const SizedBox();
                                  }),
                                )),
                              ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: ColorPallete.textSecondary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: TextField(
                                          controller: controller,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              child: const Icon(Icons.send),
                                              onTap: () {
                                                final text = controller.text.trim();
                                                if (text.isEmpty) return; // Don't send empty messages

                                                context.read<MessageBloc>().add(
                                                    SendMessageEvent(
                                                        messageParams: MessageParams(
                                                            message: text,
                                                            senderId:
                                                                getIt<User>()
                                                                    .user!
                                                                    .id
                                                                    .toString(),
                                                            receiverId:
                                                                selectedChat!.id
                                                                    .toString(),
                                                            receiverName:
                                                                selectedChatName,
                                                            isSender: true,
                                                            roomId: selectedChat!
                                                                .roomId,
                                                            createdAt:
                                                                DateTime.now(),
                                                            senderName: getIt<
                                                                    User>()
                                                                .user!
                                                                .firstName)));

                                                controller.clear();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _customChatBar() {
    return CustomAppBar(children: [
      if (!isChatSelected) const Text("Chats"),
      if (isChatSelected) Text("Chats > $selectedChatName"),
      const Spacer(),
      IconButton(
        onPressed: () {
          _chatPageKey.currentState?.openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: ColorPallete.textPrimary,
        ),
      ),
    ]);
  }
}
