using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class addImageToProvinceTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ImageUrl",
                table: "Provinces",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ImageUrl",
                table: "Provinces");
        }
    }
}
