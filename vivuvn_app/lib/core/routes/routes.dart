const String splashRoute = '/splash';

const String loginRoute = '/login';
const String registerRoute = '/register';

const String homeRoute = '/';
const String profileRoute = '/profile';
const String notificationRoute = '/notifications';

// itineraries routes
const String itineraryRoute = '/itineraries';
const String itineraryDetailRoute = '/itineraries/:id';
String createItineraryDetailRoute(final int id) => '/itineraries/$id';
const String publicItineraryViewRoute = '/public-itineraries/:id';
String createPublicItineraryViewRoute(final String id) => '/public-itineraries/$id';
const String locationDetailRoute = '/location/:id';

// restaurants routes
const String nearbyRestaurantRoute = '/nearby-restaurants';

// hotels routes
const String nearbyHotelRoute = '/nearby-hotels';

// chat routes
const String chatRoute = '/itineraries/:id/chat';
String createChatRoute(final int itineraryId) =>
    '/itineraries/$itineraryId/chat';
