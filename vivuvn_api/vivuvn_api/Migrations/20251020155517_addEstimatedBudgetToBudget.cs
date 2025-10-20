using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class addEstimatedBudgetToBudget : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "EstimatedBudget",
                table: "Budgets",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EstimatedBudget",
                table: "Budgets");
        }
    }
}
