using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class AddNormalizedName : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "NameNormalized",
                table: "Provinces",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "NameNormalized",
                table: "Locations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NameNormalized",
                table: "Provinces");

            migrationBuilder.DropColumn(
                name: "NameNormalized",
                table: "Locations");
        }
    }
}
