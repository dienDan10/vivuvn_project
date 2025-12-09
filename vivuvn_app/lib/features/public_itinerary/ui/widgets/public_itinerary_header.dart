import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../itinerary/itinerary-detail/member/data/model/member.dart';
import '../../../itinerary/itinerary-detail/schedule/model/transportation_mode.dart';
import '../../../itinerary/view-itinerary-list/models/itinerary.dart';

class PublicItineraryHeader extends StatelessWidget {
  final Itinerary itinerary;
  final List<Member> members;

  const PublicItineraryHeader({
    required this.itinerary,
    required this.members,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.network(
            itinerary.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (final context, final error, final stackTrace) => Container(
              color: colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image, size: 64),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    itinerary.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _InfoColumn(
                          icon: Icons.location_on,
                          label: itinerary.destinationProvinceName,
                          secondaryIcon: Icons.calendar_today,
                          secondaryLabel:
                              '${DateFormat('dd/MM/yyyy').format(itinerary.startDate)} - ${DateFormat('dd/MM/yyyy').format(itinerary.endDate)}',
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoColumn(
                          avatarUrl: itinerary.owner.userPhoto,
                          label: itinerary.owner.username,
                          subtitle: itinerary.owner.email,
                          icon: itinerary.transportationVehicle.isNotEmpty
                              ? TransportationMode.getIcon(itinerary.transportationVehicle)
                              : Icons.directions,
                          secondaryLabel: itinerary.transportationVehicle.isNotEmpty
                              ? itinerary.transportationVehicle
                              : 'Chưa cập nhật',
                          tertiaryIcon: Icons.group,
                          tertiaryLabel: '${members.length}/${itinerary.groupSize} người',
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final IconData? secondaryIcon;
  final String? secondaryLabel;
  final IconData? tertiaryIcon;
  final String? tertiaryLabel;
  final String? subtitle;
  final String? avatarUrl;
  final ThemeData theme;

  const _InfoColumn({
    required this.icon,
    required this.label,
    required this.theme,
    this.secondaryIcon,
    this.secondaryLabel,
    this.tertiaryIcon,
    this.tertiaryLabel,
    this.subtitle,
    this.avatarUrl,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeadingAvatarOrIcon(),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (secondaryIcon != null && secondaryLabel != null) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(secondaryIcon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  secondaryLabel!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (tertiaryIcon != null && tertiaryLabel != null) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(tertiaryIcon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  tertiaryLabel!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLeadingAvatarOrIcon() {
    if (avatarUrl == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, size: 18, color: Colors.white),
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.white,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? const Icon(
                Icons.person,
                size: 16,
                color: Colors.black87,
              )
            : null,
      ),
    );
  }
}

