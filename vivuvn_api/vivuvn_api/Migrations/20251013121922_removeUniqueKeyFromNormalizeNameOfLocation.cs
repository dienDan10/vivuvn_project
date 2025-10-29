using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class removeUniqueKeyFromNormalizeNameOfLocation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Locations_NameNormalized",
                table: "Locations");

            migrationBuilder.CreateIndex(
                name: "IX_Locations_NameNormalized",
                table: "Locations",
                column: "NameNormalized");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Locations_NameNormalized",
                table: "Locations");

            migrationBuilder.CreateIndex(
                name: "IX_Locations_NameNormalized",
                table: "Locations",
                column: "NameNormalized",
                unique: true);
        }
    }
}
