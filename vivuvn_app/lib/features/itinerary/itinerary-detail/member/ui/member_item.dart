import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../common/helper/image_util.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../data/model/member.dart';
import 'manage_member_modal.dart';

class MemberItem extends ConsumerStatefulWidget {
  final Member member;
  const MemberItem({super.key, required this.member});

  @override
  ConsumerState<MemberItem> createState() => _MemberItemState();
}

class _MemberItemState extends ConsumerState<MemberItem> {
  void _openEditMemberDialog() {
    final bool isOwner =
        ref.read(itineraryDetailControllerProvider).itinerary?.isOwner ?? false;
    if (!isOwner) return;

    // Don't allow kicking the owner
    if (widget.member.role.toLowerCase() == 'owner') return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (final context) => ManageMemberModal(member: widget.member),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isOwner = widget.member.role.toLowerCase() == 'owner';

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _openEditMemberDialog,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar with status indicator
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isOwner
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: ImageUtil.buildAvatarWidget(
                        imageUrl: widget.member.photo,
                        radius: 28,
                      ),
                    ),
                    if (isOwner)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.star,
                            size: 12,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Member info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.member.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isOwner) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Owner',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.member.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.outline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.member.phoneNumber != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.member.phoneNumber!,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Joined date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM').format(widget.member.joinedAt),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy').format(widget.member.joinedAt),
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
