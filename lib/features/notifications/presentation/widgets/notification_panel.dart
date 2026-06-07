import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_event.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_state.dart';
import 'package:hackathon/features/notifications/presentation/widgets/notification_item_widget.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(NotificationsLoadRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final state = context.read<NotificationsBloc>().state;
      if (state is NotificationsLoaded && state.hasMore && !state.isLoadingMore) {
        context.read<NotificationsBloc>().add(NotificationsLoadMoreRequested(state.notifications.length));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: ColorPallete.transparent,
        child: Container(
          width: swidth > 600 ? 400 : swidth * 0.85,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 30, 30, 30),
            boxShadow: [
              BoxShadow(color: ColorPallete.textSecondary, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context),
              const Divider(height: 1, color: ColorPallete.divider),
              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: ColorPallete.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              final unreadCount = (state is NotificationsLoaded) ? state.unreadCount : 0;
              if (unreadCount == 0) return const SizedBox.shrink();

              return TextButton(
                onPressed: () {
                  context.read<NotificationsBloc>().add(NotificationsMarkAllReadRequested());
                },
                child: const Text(
                  'Mark all as read',
                  style: TextStyle(color: ColorPallete.redPrimary, fontSize: 13),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: ColorPallete.textSecondary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return _buildSkeleton();
        } else if (state is NotificationsEmpty) {
          return _buildEmpty();
        } else if (state is NotificationsError) {
          return Center(child: Text(state.message, style: const TextStyle(color: ColorPallete.error)));
        } else if (state is NotificationsLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.filteredNotifications.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.filteredNotifications.length) {
                return NotificationItemWidget(
                  notification: state.filteredNotifications[index],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: ColorPallete.divider, borderRadius: BorderRadius.circular(20))),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 12, color: ColorPallete.divider),
                  const SizedBox(height: 8),
                  Container(width: double.infinity, height: 10, color: ColorPallete.divider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done_all, size: 64, color: ColorPallete.textPrimary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            "You're all caught up",
            style: TextStyle(color: ColorPallete.textPrimary.withValues(alpha: 0.5), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
