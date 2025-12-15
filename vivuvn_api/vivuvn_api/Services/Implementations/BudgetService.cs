using AutoMapper;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class BudgetService(IUnitOfWork _unitOfWork, IMapper _mapper, IImageService _imageService) : IBudgetService
    {
        public async Task<BudgetDto?> GetBudgetByItineraryIdAsync(int itineraryId)
        {
            var budget = await _unitOfWork.Budgets
                .GetQueryable()
                .Where(b => b.ItineraryId == itineraryId)
                .Include(b => b.Items)
                    .ThenInclude(i => i.BudgetType)
                .Include(b => b.Items)
                    .ThenInclude(i => i.PaidByMember)
                        .ThenInclude(m => m.User)
                .AsSplitQuery()
                .AsNoTracking()
                .FirstOrDefaultAsync();

            if (budget == null)
            {
                throw new ArgumentException($"Ngân sách cho lịch trình có ID {itineraryId} không tồn tại.");
            }
            return _mapper.Map<BudgetDto>(budget);
        }

        public async Task<IEnumerable<BudgetItemDto>> GetBudgetItemsAsync(int itineraryId)
        {
            var budget = await _unitOfWork.Budgets.GetOneAsync(b => b.ItineraryId == itineraryId);
            if (budget == null)
            {
                throw new ArgumentException($"Ngân sách cho lịch trình có ID {itineraryId} không tồn tại.");
            }
            var budgetItems = await _unitOfWork.Budgets.GetBudgetItemsByBudgetIdAsync(budget.BudgetId);

            return _mapper.Map<IEnumerable<BudgetItemDto>>(budgetItems);
        }

        public async Task<IEnumerable<BudgetTypeDto>> GetBudgetTypesAsync()
        {
            var budgetTypes = await _unitOfWork.Budgets.GetAllBudgetTypesAsync();
            return _mapper.Map<IEnumerable<BudgetTypeDto>>(budgetTypes);
        }

        public async Task<BudgetItemDto?> AddBudgetItemAsync(int itineraryId, CreateBudgetItemRequestDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag)
                ?? throw new ArgumentException($"Lịch trình có ID {itineraryId} không tồn tại.");

            var budget = await _unitOfWork.Budgets.GetOneAsync(b => b.ItineraryId == itineraryId);

            if (budget == null)
            {
                throw new ArgumentException($"Ngân sách cho lịch trình có ID {itineraryId} không tồn tại.");
            }

            var budgetItem = new BudgetItem
            {
                Name = request.Name ?? "New Budget Item",
                BudgetId = budget.BudgetId,
                Cost = request.Cost,
                Date = request.Date,
                BudgetTypeId = request.BudgetTypeId,
                PaidByMemberId = request.MemberId,
                Details = request.Details,
                BillPhotoUrl = request.BillPhotoUrl
            };

            await _unitOfWork.Budgets.AddBudgetItemAsync(budgetItem);
            await _unitOfWork.SaveChangesAsync();

            budgetItem = await _unitOfWork.Budgets.GetBudgetItemByIdAsync(budgetItem.Id);

            return _mapper.Map<BudgetItemDto>(budgetItem);
        }

        public async Task<BudgetDto?> UpdateBudgetAsync(int itineraryId, UpdateBudgetRequestDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag)
                ?? throw new ArgumentException($"Lịch trình có ID {itineraryId} không tồn tại.");

            var budget = await _unitOfWork.Budgets.GetOneAsync(b => b.ItineraryId == itineraryId, tracked: true);
            if (budget is null)
            {
                throw new ArgumentException($"Ngân sách cho lịch trình có ID {itineraryId} không tồn tại.");
            }

            if (request.EstimatedBudget.HasValue && request.EstimatedBudget.Value >= 0)
            {
                budget.EstimatedBudget = request.EstimatedBudget.Value;
            }
            _unitOfWork.Budgets.Update(budget);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<BudgetDto>(budget);
        }

        public async Task<BudgetItemDto?> UpdateBudgetItemAsync(int itemId, UpdateBudgetItemRequestDto request)
        {
            var item = await _unitOfWork.Budgets.GetBudgetItemByIdAsync(itemId, track: false);

            if (item is null)
            {
                throw new ArgumentException($"Mục ngân sách có ID {itemId} không tồn tại.");
            }

            if (request.Name is not null) item.Name = request.Name;

            if (request.Date is not null) item.Date = request.Date.Value;

            if (request.Cost is not null && request.Cost.Value > 0) item.Cost = request.Cost.Value;

            if (request.BudgetTypeId is not null) item.BudgetTypeId = request.BudgetTypeId.Value;

            if (request.MemberId is not null) item.PaidByMemberId = request.MemberId;

            if (request.Details is not null) item.Details = request.Details;

            if (request.BillPhotoUrl is not null) item.BillPhotoUrl = request.BillPhotoUrl;

            var updatedItem = await _unitOfWork.Budgets.UpdateBudgetItemAsync(item);

            await _unitOfWork.SaveChangesAsync();

            return _mapper.Map<BudgetItemDto>(updatedItem);
        }

        public async Task<BudgetItemDto?> DeleteBudgetItemAsync(int itemId)
        {
            var deletedItem = await _unitOfWork.Budgets.DeleteBudgetItemAsync(itemId);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<BudgetItemDto>(deletedItem);
        }

        public async Task<UploadBudgetItemBillImageResponse> UploadBudgetItemImageAsync(IFormFile image)
        {
            var imageUrl = await _imageService.UploadImageAsync(image);
            return new UploadBudgetItemBillImageResponse
            {
                ImageUrl = imageUrl
            };
        }
    }
}
