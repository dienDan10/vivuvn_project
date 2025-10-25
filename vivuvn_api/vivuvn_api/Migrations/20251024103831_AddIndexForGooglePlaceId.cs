using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class AddIndexForGooglePlaceId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "GooglePlaceId",
                table: "Restaurant",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "GooglePlaceId",
                table: "Locations",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "GooglePlaceId",
                table: "Hotel",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Restaurant_GooglePlaceId",
                table: "Restaurant",
                column: "GooglePlaceId");

            migrationBuilder.CreateIndex(
                name: "IX_Locations_GooglePlaceId",
                table: "Locations",
                column: "GooglePlaceId");

            migrationBuilder.CreateIndex(
                name: "IX_Hotel_GooglePlaceId",
                table: "Hotel",
                column: "GooglePlaceId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Restaurant_GooglePlaceId",
                table: "Restaurant");

            migrationBuilder.DropIndex(
                name: "IX_Locations_GooglePlaceId",
                table: "Locations");

            migrationBuilder.DropIndex(
                name: "IX_Hotel_GooglePlaceId",
                table: "Hotel");

            migrationBuilder.AlterColumn<string>(
                name: "GooglePlaceId",
                table: "Restaurant",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "GooglePlaceId",
                table: "Locations",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "GooglePlaceId",
                table: "Hotel",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);
        }
    }
}
