import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/toast/global_toast.dart';
import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../service/member_service.dart';
import '../state/member_state.dart';

class MemberController extends AutoDisposeNotifier<MemberState> {
  @override
  MemberState build() {
    return MemberState();
  }

  Future<void> loadMembers() async {
    state = state.copyWith(isLoadingMembers: true, loadingMembersError: null);
    final itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId;
    try {
      final members = await ref
          .read(memberServiceProvider)
          .fetchMembers(itineraryId!);

      state = state.copyWith(members: members, isLoadingMembers: false);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        loadingMembersError: errorMsg,
        isLoadingMembers: false,
      );
    } catch (e) {
      state = state.copyWith(
        loadingMembersError: 'unknown error',
        isLoadingMembers: false,
      );
    } finally {
      state = state.copyWith(isLoadingMembers: false);
    }
  }

  Future<void> kickMember(final int memberId) async {
    final itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId;
    state = state.copyWith(isKickingMember: true, kickingMemberError: null);
    try {
      await ref.read(memberServiceProvider).kickMember(itineraryId!, memberId);
      // Remove member from state
      final updatedMembers = state.members
          .where((final member) => member.memberId != memberId)
          .toList();
      state = state.copyWith(members: updatedMembers);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(kickingMemberError: errorMsg);
    } catch (e) {
      state = state.copyWith(kickingMemberError: 'Có lỗi xảy ra');
    } finally {
      state = state.copyWith(isKickingMember: false);
    }
  }

  Future<void> sendNotificationToAllMembers(
    final String title,
    final String message, {
    final bool? sendEmail = false,
    required final BuildContext context,
  }) async {
    final itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId;
    state = state.copyWith(
      isSendingNotification: true,
      sendingNotificationError: null,
    );
    try {
      await ref
          .read(memberServiceProvider)
          .sendNotification(itineraryId!, title, message, sendEmail: sendEmail);
      if (context.mounted) {
        context.pop();
        GlobalToast.showSuccessToast(
          context,
          message: 'Gửi thông báo thành công',
        );
      }
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(sendingNotificationError: errorMsg);
    } catch (e) {
      state = state.copyWith(sendingNotificationError: 'Có lỗi xảy ra');
    } finally {
      state = state.copyWith(isSendingNotification: false);
    }
  }

  void resetKickingMemberError() {
    state = state.copyWith(kickingMemberError: null);
  }
}

final memberControllerProvider =
    AutoDisposeNotifierProvider<MemberController, MemberState>(
      () => MemberController(),
    );
