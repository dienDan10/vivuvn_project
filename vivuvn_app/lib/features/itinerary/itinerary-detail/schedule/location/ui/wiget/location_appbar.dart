import 'package:flutter/material.dart';

import '../../model/location_detail.dart';

class LocationAppBar extends StatelessWidget {
  final LocationDetail location;
  final bool showTitle;
  final TabController tabController;

  const LocationAppBar({
    super.key,
    required this.location,
    required this.showTitle,
    required this.tabController,
  });

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(showTitle ? 0.05 : 0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: showTitle ? Colors.black : Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: AnimatedOpacity(
        opacity: showTitle ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Text(
          location.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 16, bottom: 50),
        title: AnimatedOpacity(
          opacity: showTitle ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Text(
            location.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            location.photos.isNotEmpty
                ? Image.network(location.photos.first, fit: BoxFit.cover)
                : Image.asset(
                    'assets/images/image-placeholder.jpeg',
                    fit: BoxFit.cover,
                  ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent, Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: Colors.white,
          child: TabBar(
            controller: tabController,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Tổng quan'),
              Tab(text: 'Hình ảnh'),
              Tab(text: 'Thông tin'),
            ],
          ),
        ),
      ),
    );
  }
}
