using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class addEntityToDbContext : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ItineraryHotels_Hotel_HotelId",
                table: "ItineraryHotels");

            migrationBuilder.DropForeignKey(
                name: "FK_ItineraryRestaurants_Restaurant_RestaurantId",
                table: "ItineraryRestaurants");

            migrationBuilder.DropForeignKey(
                name: "FK_LocationHotel_Hotel_NearbyHotelsId",
                table: "LocationHotel");

            migrationBuilder.DropForeignKey(
                name: "FK_LocationRestaurant_Restaurant_NearbyRestaurantsId",
                table: "LocationRestaurant");

            migrationBuilder.DropForeignKey(
                name: "FK_Photo_Hotel_HotelId",
                table: "Photo");

            migrationBuilder.DropForeignKey(
                name: "FK_Photo_Locations_LocationId",
                table: "Photo");

            migrationBuilder.DropForeignKey(
                name: "FK_Photo_Restaurant_RestaurantId",
                table: "Photo");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Restaurant",
                table: "Restaurant");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Photo",
                table: "Photo");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Hotel",
                table: "Hotel");

            migrationBuilder.RenameTable(
                name: "Restaurant",
                newName: "Restaurants");

            migrationBuilder.RenameTable(
                name: "Photo",
                newName: "Photos");

            migrationBuilder.RenameTable(
                name: "Hotel",
                newName: "Hotels");

            migrationBuilder.RenameIndex(
                name: "IX_Restaurant_GooglePlaceId",
                table: "Restaurants",
                newName: "IX_Restaurants_GooglePlaceId");

            migrationBuilder.RenameIndex(
                name: "IX_Photo_RestaurantId",
                table: "Photos",
                newName: "IX_Photos_RestaurantId");

            migrationBuilder.RenameIndex(
                name: "IX_Photo_LocationId",
                table: "Photos",
                newName: "IX_Photos_LocationId");

            migrationBuilder.RenameIndex(
                name: "IX_Photo_HotelId",
                table: "Photos",
                newName: "IX_Photos_HotelId");

            migrationBuilder.RenameIndex(
                name: "IX_Hotel_GooglePlaceId",
                table: "Hotels",
                newName: "IX_Hotels_GooglePlaceId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Restaurants",
                table: "Restaurants",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Photos",
                table: "Photos",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Hotels",
                table: "Hotels",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ItineraryHotels_Hotels_HotelId",
                table: "ItineraryHotels",
                column: "HotelId",
                principalTable: "Hotels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_ItineraryRestaurants_Restaurants_RestaurantId",
                table: "ItineraryRestaurants",
                column: "RestaurantId",
                principalTable: "Restaurants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_LocationHotel_Hotels_NearbyHotelsId",
                table: "LocationHotel",
                column: "NearbyHotelsId",
                principalTable: "Hotels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_LocationRestaurant_Restaurants_NearbyRestaurantsId",
                table: "LocationRestaurant",
                column: "NearbyRestaurantsId",
                principalTable: "Restaurants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Photos_Hotels_HotelId",
                table: "Photos",
                column: "HotelId",
                principalTable: "Hotels",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Photos_Locations_LocationId",
                table: "Photos",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Photos_Restaurants_RestaurantId",
                table: "Photos",
                column: "RestaurantId",
                principalTable: "Restaurants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ItineraryHotels_Hotels_HotelId",
                table: "ItineraryHotels");

            migrationBuilder.DropForeignKey(
                name: "FK_ItineraryRestaurants_Restaurants_RestaurantId",
                table: "ItineraryRestaurants");

            migrationBuilder.DropForeignKey(
                name: "FK_LocationHotel_Hotels_NearbyHotelsId",
                table: "LocationHotel");

            migrationBuilder.DropForeignKey(
                name: "FK_LocationRestaurant_Restaurants_NearbyRestaurantsId",
                table: "LocationRestaurant");

            migrationBuilder.DropForeignKey(
                name: "FK_Photos_Hotels_HotelId",
                table: "Photos");

            migrationBuilder.DropForeignKey(
                name: "FK_Photos_Locations_LocationId",
                table: "Photos");

            migrationBuilder.DropForeignKey(
                name: "FK_Photos_Restaurants_RestaurantId",
                table: "Photos");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Restaurants",
                table: "Restaurants");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Photos",
                table: "Photos");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Hotels",
                table: "Hotels");

            migrationBuilder.RenameTable(
                name: "Restaurants",
                newName: "Restaurant");

            migrationBuilder.RenameTable(
                name: "Photos",
                newName: "Photo");

            migrationBuilder.RenameTable(
                name: "Hotels",
                newName: "Hotel");

            migrationBuilder.RenameIndex(
                name: "IX_Restaurants_GooglePlaceId",
                table: "Restaurant",
                newName: "IX_Restaurant_GooglePlaceId");

            migrationBuilder.RenameIndex(
                name: "IX_Photos_RestaurantId",
                table: "Photo",
                newName: "IX_Photo_RestaurantId");

            migrationBuilder.RenameIndex(
                name: "IX_Photos_LocationId",
                table: "Photo",
                newName: "IX_Photo_LocationId");

            migrationBuilder.RenameIndex(
                name: "IX_Photos_HotelId",
                table: "Photo",
                newName: "IX_Photo_HotelId");

            migrationBuilder.RenameIndex(
                name: "IX_Hotels_GooglePlaceId",
                table: "Hotel",
                newName: "IX_Hotel_GooglePlaceId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Restaurant",
                table: "Restaurant",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Photo",
                table: "Photo",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Hotel",
                table: "Hotel",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ItineraryHotels_Hotel_HotelId",
                table: "ItineraryHotels",
                column: "HotelId",
                principalTable: "Hotel",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_ItineraryRestaurants_Restaurant_RestaurantId",
                table: "ItineraryRestaurants",
                column: "RestaurantId",
                principalTable: "Restaurant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_LocationHotel_Hotel_NearbyHotelsId",
                table: "LocationHotel",
                column: "NearbyHotelsId",
                principalTable: "Hotel",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_LocationRestaurant_Restaurant_NearbyRestaurantsId",
                table: "LocationRestaurant",
                column: "NearbyRestaurantsId",
                principalTable: "Restaurant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Photo_Hotel_HotelId",
                table: "Photo",
                column: "HotelId",
                principalTable: "Hotel",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Photo_Locations_LocationId",
                table: "Photo",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Photo_Restaurant_RestaurantId",
                table: "Photo",
                column: "RestaurantId",
                principalTable: "Restaurant",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
