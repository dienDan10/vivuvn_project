using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class modifyItineraryTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Destination",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "StartLocation",
                table: "Itineraries");

            migrationBuilder.AddColumn<int>(
                name: "DestinationProvinceId",
                table: "Itineraries",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "GroupSize",
                table: "Itineraries",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "StartProvinceId",
                table: "Itineraries",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Itineraries_DestinationProvinceId",
                table: "Itineraries",
                column: "DestinationProvinceId");

            migrationBuilder.CreateIndex(
                name: "IX_Itineraries_StartProvinceId",
                table: "Itineraries",
                column: "StartProvinceId");

            migrationBuilder.AddForeignKey(
                name: "FK_Itineraries_Provinces_DestinationProvinceId",
                table: "Itineraries",
                column: "DestinationProvinceId",
                principalTable: "Provinces",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Itineraries_Provinces_StartProvinceId",
                table: "Itineraries",
                column: "StartProvinceId",
                principalTable: "Provinces",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Itineraries_Provinces_DestinationProvinceId",
                table: "Itineraries");

            migrationBuilder.DropForeignKey(
                name: "FK_Itineraries_Provinces_StartProvinceId",
                table: "Itineraries");

            migrationBuilder.DropIndex(
                name: "IX_Itineraries_DestinationProvinceId",
                table: "Itineraries");

            migrationBuilder.DropIndex(
                name: "IX_Itineraries_StartProvinceId",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "DestinationProvinceId",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "GroupSize",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "StartProvinceId",
                table: "Itineraries");

            migrationBuilder.AddColumn<string>(
                name: "Destination",
                table: "Itineraries",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "StartLocation",
                table: "Itineraries",
                type: "nvarchar(max)",
                nullable: true);
        }
    }
}
