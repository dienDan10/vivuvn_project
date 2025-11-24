using vivuvn_api.DTOs.Request;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class UserDeviceService(IUnitOfWork _unitOfWork) : IUserDeviceService
    {
        public async Task RegisterDeviceAsync(int userId, RegisterDeviceRequestDto request)
        {
            var existingDevice = await _unitOfWork.UserDevices.GetOneAsync(d => d.UserId == userId && d.DeviceType == request.DeviceType, tracked: true);

            if (existingDevice != null)
            {
                // update the time stamp and return
                existingDevice.FcmToken = request.FcmToken;
                existingDevice.LastUsedAt = DateTime.UtcNow;
                existingDevice.IsActive = true;
                existingDevice.DeviceName = request.DeviceName;

                _unitOfWork.UserDevices.Update(existingDevice);
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // create new device record
            var newDevice = new UserDevice
            {
                UserId = userId,
                FcmToken = request.FcmToken,
                DeviceType = request.DeviceType,
                DeviceName = request.DeviceName,
                CreatedAt = DateTime.UtcNow,
                LastUsedAt = DateTime.UtcNow,
                IsActive = true
            };

            await _unitOfWork.UserDevices.AddAsync(newDevice);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task CleanupStaleDevicesAsync(int daysThreshold = 30)
        {
            var cutoffDate = DateTime.UtcNow.AddDays(-daysThreshold);

            var staleDevices = await _unitOfWork.UserDevices.GetAllAsync(
                d => d.LastUsedAt < cutoffDate && d.IsActive
            );

            foreach (var device in staleDevices)
            {
                device.IsActive = false;
                _unitOfWork.UserDevices.Update(device);
            }

            await _unitOfWork.SaveChangesAsync();
        }

        public async Task DeactivateDeviceAsync(string fcmToken)
        {
            var device = await _unitOfWork.UserDevices.GetOneAsync(d => d.FcmToken == fcmToken);
            if (device != null)
            {
                device.IsActive = false;
                _unitOfWork.UserDevices.Update(device);
                await _unitOfWork.SaveChangesAsync();
            }
        }

    }
}
