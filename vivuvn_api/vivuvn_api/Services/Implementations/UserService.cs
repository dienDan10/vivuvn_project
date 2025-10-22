using AutoMapper;
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
    public class UserService(IUnitOfWork _unitOfWork, IMapper _mapper) : IUserService
    {
        public async Task<UserDto> GetProfileAsync(string email)
        {
            var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == email, includeProperties: "UserRoles,UserRoles.Role");

            if (user == null)
            {
                throw new KeyNotFoundException("User not found.");
            }
            return _mapper.Map<UserDto>(user);
        }

        public async Task<UserDto?> LockUserAccountAsync(int userId)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user == null)
            {
                return null;
            }
            user.LockoutEnd = DateTime.UtcNow.AddYears(100);
            _unitOfWork.Users.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<UserDto>(user);
        }

        public async Task<UserDto?> UnlockUserAccountAsync(int userId)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user == null)
            {
                return null;
            }
            user.LockoutEnd = null;
            _unitOfWork.Users.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<UserDto>(user);
        }

        public async Task<PaginatedResponseDto<UserDto>> GetAllUsersAsync(GetAllUsersRequestDto requestDto)
        {
            // Build filter expression with optional role filtering
            Expression<Func<User, bool>> filter = u =>
                (string.IsNullOrEmpty(requestDto.Role) || u.UserRoles.Any(ur => ur.Role.Name == requestDto.Role)) &&
                (string.IsNullOrEmpty(requestDto.Username) || u.Username.Contains(requestDto.Username)) &&
                (string.IsNullOrEmpty(requestDto.Email) || u.Email.Contains(requestDto.Email)) &&
                (string.IsNullOrEmpty(requestDto.PhoneNumber) || (u.PhoneNumber != null && u.PhoneNumber.Contains(requestDto.PhoneNumber)));

            // Build orderBy function
            Func<IQueryable<User>, IOrderedQueryable<User>>? orderBy = null;

            if (!string.IsNullOrEmpty(requestDto.SortBy))
            {
                orderBy = requestDto.SortBy.ToLower() switch
                {
                    "username" => q => requestDto.IsDescending ? q.OrderByDescending(u => u.Username) : q.OrderBy(u => u.Username),
                    "email" => q => requestDto.IsDescending ? q.OrderByDescending(u => u.Email) : q.OrderBy(u => u.Email),
                    "phoneNumber" => q => requestDto.IsDescending ? q.OrderByDescending(u => u.PhoneNumber) : q.OrderBy(u => u.PhoneNumber),
                    "id" => q => requestDto.IsDescending ? q.OrderByDescending(u => u.Id) : q.OrderBy(u => u.Id),
                    _ => q => q.OrderBy(u => u.Id)
                };
            }
            else
            {
                orderBy = q => q.OrderBy(u => u.Id);
            }

            // Get paginated data with UserRoles included
            var (items, totalCount) = await _unitOfWork.Users.GetPagedAsync(
                filter: filter,
                includeProperties: "UserRoles,UserRoles.Role",
                orderBy: orderBy,
                pageNumber: requestDto.PageNumber,
                pageSize: requestDto.PageSize
            );

            var userDtos = _mapper.Map<IEnumerable<UserDto>>(items);

            return new PaginatedResponseDto<UserDto>
            {
                Data = userDtos,
                PageNumber = requestDto.PageNumber,
                PageSize = requestDto.PageSize,
                TotalCount = totalCount,
                TotalPages = (int)Math.Ceiling(totalCount / (double)requestDto.PageSize),
                HasPreviousPage = requestDto.PageNumber > 1,
                HasNextPage = requestDto.PageNumber < (int)Math.Ceiling(totalCount / (double)requestDto.PageSize)
            };
        }
    }
}
