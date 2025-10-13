using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class RemoveItineraryDayCostTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ItineraryDayCosts");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ItineraryDayCosts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BudgetItemId = table.Column<int>(type: "int", nullable: false),
                    ItineraryDayId = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ItineraryDayCosts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ItineraryDayCosts_BudgetItems_BudgetItemId",
                        column: x => x.BudgetItemId,
                        principalTable: "BudgetItems",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ItineraryDayCosts_ItineraryDays_ItineraryDayId",
                        column: x => x.ItineraryDayId,
                        principalTable: "ItineraryDays",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryDayCosts_BudgetItemId",
                table: "ItineraryDayCosts",
                column: "BudgetItemId");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryDayCosts_ItineraryDayId",
                table: "ItineraryDayCosts",
                column: "ItineraryDayId");
        }
    }
}
