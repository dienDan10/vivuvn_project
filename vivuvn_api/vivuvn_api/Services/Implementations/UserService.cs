using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class UserService(IUnitOfWork _unitOfWork, IMapper _mapper, IImageService _imageService) : IUserService
    {
        public async Task<UserDto> GetProfileAsync(string email)
        {
            var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == email, includeProperties: "UserRoles,UserRoles.Role");

            if (user == null)
            {
                throw new KeyNotFoundException("Không tìm thấy người dùng.");
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

        public async Task<string?> ChangeAvatarAsync(int userId, IFormFile avatar)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user is null)
            {
                return null;
            }

            var avatarUrl = await _imageService.UploadImageAsync(avatar);

            // update user avatar
            user.UserPhoto = avatarUrl;
            _unitOfWork.Users.Update(user);
            await _unitOfWork.SaveChangesAsync();

            return avatarUrl;
        }

        public async Task<string?> ChangeUsername(int userId, string name)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user is null)
            {
                return null;
            }
            user.Username = name;
            _unitOfWork.Users.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return name;
        }
    }
}
