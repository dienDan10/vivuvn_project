using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class RemoveUserId1FromItineraryMember : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ItineraryMembers_Users_UserId1",
                table: "ItineraryMembers");

            migrationBuilder.DropIndex(
                name: "IX_ItineraryMembers_UserId1",
                table: "ItineraryMembers");

            migrationBuilder.DropColumn(
                name: "UserId1",
                table: "ItineraryMembers");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "UserId1",
                table: "ItineraryMembers",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMembers_UserId1",
                table: "ItineraryMembers",
                column: "UserId1");

            migrationBuilder.AddForeignKey(
                name: "FK_ItineraryMembers_Users_UserId1",
                table: "ItineraryMembers",
                column: "UserId1",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}
