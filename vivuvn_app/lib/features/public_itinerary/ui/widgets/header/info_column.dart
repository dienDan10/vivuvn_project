import 'package:flutter/material.dart';

class InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final IconData? secondaryIcon;
  final String? secondaryLabel;
  final IconData? tertiaryIcon;
  final String? tertiaryLabel;
  final String? subtitle;
  final String? avatarUrl;
  final ThemeData theme;

  const InfoColumn({
    required this.icon,
    required this.label,
    required this.theme,
    this.secondaryIcon,
    this.secondaryLabel,
    this.tertiaryIcon,
    this.tertiaryLabel,
    this.subtitle,
    this.avatarUrl,
    super.key,
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

