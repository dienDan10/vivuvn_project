class FavouritePlacesResponse {
  final int idInWishlist;
  final int locationId;
  final String name;
  final String description;
  final String imageUrl;
  final String provinceName;

  FavouritePlacesResponse({
    required this.idInWishlist,
    required this.locationId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.provinceName,
  });

  factory FavouritePlacesResponse.fromJson(final Map<String, dynamic> json) {
    return FavouritePlacesResponse(
      idInWishlist: json['idInWishlist'] as int,
      locationId: json['locationId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      provinceName: json['provinceName'] as String,
    );
  }

  //Fake data for testing
  static List<FavouritePlacesResponse> fakeData() {
    return [
      FavouritePlacesResponse(
        idInWishlist: 1,
        locationId: 101,
        name: 'Bãi biển Mỹ Khê',
        description:
            'Bãi biển Mỹ Khê là một trong những bãi biển đẹp nhất Việt Nam, nổi tiếng với cát trắng mịn và nước biển trong xanh.',
        imageUrl:
            'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
        provinceName: 'Đà Nẵng',
      ),
      FavouritePlacesResponse(
        idInWishlist: 2,
        locationId: 102,
        name: 'Cầu Rồng',
        description:
            'Cầu Rồng là biểu tượng hiện đại của Đà Nẵng, nổi bật với thiết kế hình con rồng phun lửa và nước vào cuối tuần.',
        imageUrl:
            'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=400',
        provinceName: 'Đà Nẵng',
      ),
      FavouritePlacesResponse(
        idInWishlist: 3,
        locationId: 103,
        name: 'Ngũ Hành Sơn',
        description:
            'Ngũ Hành Sơn là một quần thể núi đá vôi nổi tiếng với các hang động và chùa chiền linh thiêng, thu hút nhiều du khách và phật tử.',
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400',
        provinceName: 'Đà Nẵng',
      ),
    ];
  }
}
