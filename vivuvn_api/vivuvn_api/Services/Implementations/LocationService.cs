using AutoMapper;
using LinqKit;
using System.Linq.Expressions;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class LocationService(IMapper _mapper, IUnitOfWork _unitOfWork) : ILocationService
    {
        public async Task<IEnumerable<SearchLocationDto>> SearchLocationAsync(string? searchQuery,
            int? limit = Constants.DefaultPageSize)
        {
            if (string.IsNullOrEmpty(searchQuery))
            {
                return [];
            }

            var searchQueryNormalized = TextHelper.ToSearchFriendly(searchQuery);
            var locations = await _unitOfWork.Locations
                .GetAllAsync(l => l.NameNormalized.Contains(searchQueryNormalized), limit: limit);

            return _mapper.Map<IEnumerable<SearchLocationDto>>(locations);
        }

        public async Task<PaginatedResponseDto<LocationDto>> GetAllLocationsAsync(GetAllLocationsRequestDto requestDto)
        {
            // Build filter expression
            var predicate = PredicateBuilder.New<Location>(l => !l.DeleteFlag);

            if (!string.IsNullOrEmpty(requestDto.Name))
            {
                var searchQueryNormalized = TextHelper.ToSearchFriendly(requestDto.Name);
                predicate = predicate.And(l => l.NameNormalized.Contains(searchQueryNormalized));
            }

            if (requestDto.ProvinceId.HasValue)
            {
                predicate = predicate.And(l => l.ProvinceId == requestDto.ProvinceId.Value);
            }


            // Build order by expression
            Func<IQueryable<Location>, IOrderedQueryable<Location>>? orderBy = null;
            if (!string.IsNullOrEmpty(requestDto.SortBy))
            {
                orderBy = requestDto.SortBy.ToLower() switch
                {
                    "name" => q => requestDto.IsDescending ? q.OrderByDescending(l => l.NameNormalized) : q.OrderBy(l => l.NameNormalized),
                    "rating" => q => requestDto.IsDescending ? q.OrderByDescending(l => l.Rating) : q.OrderBy(l => l.Rating),
                    _ => q => q.OrderBy(l => l.NameNormalized)
                };
            }
            else
            {
                orderBy = q => q.OrderBy(l => l.NameNormalized);
            }

            // Get paginated data
            var (items, totalCount) = await _unitOfWork.Locations.GetPagedAsync(
                filter: predicate,
                orderBy: orderBy,
                pageNumber: requestDto.PageNumber,
                pageSize: requestDto.PageSize,
                includeProperties: "LocationPhotos,Province"
            );

            var locationDtos = _mapper.Map<IEnumerable<LocationDto>>(items);
            return new PaginatedResponseDto<LocationDto>
            {
                Data = locationDtos,
                PageNumber = requestDto.PageNumber,
                PageSize = requestDto.PageSize,
                TotalCount = totalCount,
                TotalPages = (int)Math.Ceiling(totalCount / (double)requestDto.PageSize),
                HasPreviousPage = requestDto.PageNumber > 1,
                HasNextPage = requestDto.PageNumber < (int)Math.Ceiling(totalCount / (double)requestDto.PageSize)
            };
        }

        public async Task<LocationDto> GetLocationByIdAsync(int id)
        {
            var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == id, includeProperties: "LocationPhotos");
            return _mapper.Map<LocationDto>(location);
        }

        private static Expression<Func<T, bool>> CombineFilters<T>(Expression<Func<T, bool>> first,
            Expression<Func<T, bool>> second)
        {
            var parameter = Expression.Parameter(typeof(T));
            var combined = Expression.Lambda<Func<T, bool>>(
                Expression.AndAlso(
                    Expression.Invoke(first, parameter),
                    Expression.Invoke(second, parameter)
                ),
                parameter
            );
            return combined;
        }
    }
}
