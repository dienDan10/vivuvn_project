using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace vivuvn_api.Migrations
{
    /// <inheritdoc />
    public partial class AddTablesForMemberFeature : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ExternalServices");

            migrationBuilder.DropTable(
                name: "ServiceTypes");

            migrationBuilder.AddColumn<string>(
                name: "InviteCode",
                table: "Itineraries",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "InviteCodeGeneratedAt",
                table: "Itineraries",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsPublic",
                table: "Itineraries",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "PaidByMemberId",
                table: "BudgetItems",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ItineraryMembers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItineraryId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Role = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    DeleteFlag = table.Column<bool>(type: "bit", nullable: false),
                    UserId1 = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ItineraryMembers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ItineraryMembers_Itineraries_ItineraryId",
                        column: x => x.ItineraryId,
                        principalTable: "Itineraries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ItineraryMembers_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ItineraryMembers_Users_UserId1",
                        column: x => x.UserId1,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ItineraryId = table.Column<int>(type: "int", nullable: true),
                    Type = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsRead = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DeleteFlag = table.Column<bool>(type: "bit", nullable: false),
                    UserId1 = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_Itineraries_ItineraryId",
                        column: x => x.ItineraryId,
                        principalTable: "Itineraries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId1",
                        column: x => x.UserId1,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ItineraryMessages",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItineraryId = table.Column<int>(type: "int", nullable: false),
                    ItineraryMemberId = table.Column<int>(type: "int", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DeleteFlag = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ItineraryMessages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ItineraryMessages_Itineraries_ItineraryId",
                        column: x => x.ItineraryId,
                        principalTable: "Itineraries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ItineraryMessages_ItineraryMembers_ItineraryMemberId",
                        column: x => x.ItineraryMemberId,
                        principalTable: "ItineraryMembers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Itineraries_InviteCode",
                table: "Itineraries",
                column: "InviteCode",
                unique: true,
                filter: "[InviteCode] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_BudgetItems_PaidByMemberId",
                table: "BudgetItems",
                column: "PaidByMemberId");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMembers_ItineraryId",
                table: "ItineraryMembers",
                column: "ItineraryId");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMembers_ItineraryId_UserId",
                table: "ItineraryMembers",
                columns: new[] { "ItineraryId", "UserId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMembers_UserId",
                table: "ItineraryMembers",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMembers_UserId1",
                table: "ItineraryMembers",
                column: "UserId1");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMessages_CreatedAt",
                table: "ItineraryMessages",
                column: "CreatedAt");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMessages_ItineraryId",
                table: "ItineraryMessages",
                column: "ItineraryId");

            migrationBuilder.CreateIndex(
                name: "IX_ItineraryMessages_ItineraryMemberId",
                table: "ItineraryMessages",
                column: "ItineraryMemberId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_CreatedAt",
                table: "Notifications",
                column: "CreatedAt");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_IsRead",
                table: "Notifications",
                column: "IsRead");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_ItineraryId",
                table: "Notifications",
                column: "ItineraryId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId1",
                table: "Notifications",
                column: "UserId1");

            migrationBuilder.AddForeignKey(
                name: "FK_BudgetItems_ItineraryMembers_PaidByMemberId",
                table: "BudgetItems",
                column: "PaidByMemberId",
                principalTable: "ItineraryMembers",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BudgetItems_ItineraryMembers_PaidByMemberId",
                table: "BudgetItems");

            migrationBuilder.DropTable(
                name: "ItineraryMessages");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "ItineraryMembers");

            migrationBuilder.DropIndex(
                name: "IX_Itineraries_InviteCode",
                table: "Itineraries");

            migrationBuilder.DropIndex(
                name: "IX_BudgetItems_PaidByMemberId",
                table: "BudgetItems");

            migrationBuilder.DropColumn(
                name: "InviteCode",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "InviteCodeGeneratedAt",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "IsPublic",
                table: "Itineraries");

            migrationBuilder.DropColumn(
                name: "PaidByMemberId",
                table: "BudgetItems");

            migrationBuilder.CreateTable(
                name: "ServiceTypes",
                columns: table => new
                {
                    ServiceTypeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ServiceTypes", x => x.ServiceTypeId);
                });

            migrationBuilder.CreateTable(
                name: "ExternalServices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItineraryDayId = table.Column<int>(type: "int", nullable: false),
                    ServiceTypeId = table.Column<int>(type: "int", nullable: false),
                    GoogleApiUri = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    GooglePlaceId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Rating = table.Column<double>(type: "float", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ExternalServices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ExternalServices_ItineraryDays_ItineraryDayId",
                        column: x => x.ItineraryDayId,
                        principalTable: "ItineraryDays",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ExternalServices_ServiceTypes_ServiceTypeId",
                        column: x => x.ServiceTypeId,
                        principalTable: "ServiceTypes",
                        principalColumn: "ServiceTypeId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ExternalServices_ItineraryDayId",
                table: "ExternalServices",
                column: "ItineraryDayId");

            migrationBuilder.CreateIndex(
                name: "IX_ExternalServices_ServiceTypeId",
                table: "ExternalServices",
                column: "ServiceTypeId");
        }
    }
}
