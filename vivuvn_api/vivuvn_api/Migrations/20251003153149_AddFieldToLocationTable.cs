using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class AddFieldToLocationTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ReviewCount",
                table: "Locations");

            migrationBuilder.RenameColumn(
                name: "OpenTime",
                table: "Locations",
                newName: "ReviewUri");

            migrationBuilder.RenameColumn(
                name: "MapPlaceId",
                table: "Locations",
                newName: "PlaceUri");

            migrationBuilder.RenameColumn(
                name: "CloseTime",
                table: "Locations",
                newName: "GooglePlaceId");

            migrationBuilder.RenameColumn(
                name: "BannerPhoto",
                table: "Locations",
                newName: "DirectionsUri");

            migrationBuilder.AlterColumn<string>(
                name: "ProvinceCode",
                table: "Provinces",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddColumn<int>(
                name: "RatingCount",
                table: "Locations",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "RatingCount",
                table: "Locations");

            migrationBuilder.RenameColumn(
                name: "ReviewUri",
                table: "Locations",
                newName: "OpenTime");

            migrationBuilder.RenameColumn(
                name: "PlaceUri",
                table: "Locations",
                newName: "MapPlaceId");

            migrationBuilder.RenameColumn(
                name: "GooglePlaceId",
                table: "Locations",
                newName: "CloseTime");

            migrationBuilder.RenameColumn(
                name: "DirectionsUri",
                table: "Locations",
                newName: "BannerPhoto");

            migrationBuilder.AlterColumn<string>(
                name: "ProvinceCode",
                table: "Provinces",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ReviewCount",
                table: "Locations",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
