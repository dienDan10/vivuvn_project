using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

using Constants = vivuvn_api.Helpers.Constants;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryMemberService(ITokenService _tokenService, IUnitOfWork _unitOfWork, IMapper _mapper, IFcmService _fcmService) : IItineraryMemberService
    {
        public async Task<InviteCodeDto> GenerateInviteCodeAsync(int itineraryId, int ownerId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Không tìm thấy lịch trình");

            if (itinerary.UserId != ownerId)
            {
                throw new UnauthorizedAccessException("Chỉ chủ lịch trình mới có thể tạo mã mời");
            }

            var inviteCode = new InviteCodeDto
            {
                InviteCode = _tokenService.CreateItineraryInviteToken(),
                GeneratedAt = DateTime.UtcNow
            };

            itinerary.InviteCode = inviteCode.InviteCode;
            itinerary.InviteCodeGeneratedAt = inviteCode.GeneratedAt;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();

            return inviteCode;
        }

        public async Task JoinItineraryByInviteCodeAsync(int userId, string inviteCode)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.InviteCode == inviteCode)
                ?? throw new ArgumentException("Mã mời không hợp lệ");

            // count the number of member and check for full
            var membersCount = await _unitOfWork.ItineraryMembers.CountAsync(itinerary.Id);
            if (membersCount >= itinerary.GroupSize)
            {
                throw new BadHttpRequestException("Lịch trình này đã đủ thành viên. Không thể tham gia.");
            }

            // check if user is already a member
            var existingMember = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itinerary.Id && im.UserId == userId, includeProperties: "User");

            if (existingMember is not null && !existingMember.DeleteFlag) // active member exists
            {
                throw new BadHttpRequestException("Người dùng đã là thành viên của lịch trình này");
            }

            if (existingMember is not null && existingMember.DeleteFlag) // inactive member exists
            {
                existingMember.DeleteFlag = false;
                _unitOfWork.ItineraryMembers.Update(existingMember);
            }
            else
            {
                // add new member
                var newMember = new ItineraryMember
                {
                    UserId = userId,
                    ItineraryId = itinerary.Id,
                    JoinedAt = DateTime.UtcNow,
                    DeleteFlag = false
                };
                await _unitOfWork.ItineraryMembers.AddAsync(newMember);
            }

            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            // create notification for owner
            var notification = new Notification
            {
                UserId = itinerary.UserId,
                ItineraryId = itinerary.Id,
                Type = Constants.NotificationType_MemberJoined,
                Title = "Có thành viên mới tham gia",
                Message = $"{user?.Username ?? "Có thành viên mới"} đã tham gia vào lịch trình {itinerary.Name} của bạn.",
                CreatedAt = DateTime.UtcNow,
            };
            await _unitOfWork.Notifications.AddAsync(notification);
            await _unitOfWork.SaveChangesAsync();

            // send notification to owner
            var fcmData = new Dictionary<string, string>
            {
                {"itineraryId", itinerary.Id.ToString(),
                {"type", Constants.NotificationType_MemberJoined },
            };

            await _fcmService.SendNotificationToUserAsync(itinerary.UserId,
                "Có thành viên mới tham gia",
                $"{user?.Username ?? "Có thành viên mới"} đã tham gia vào lịch trình {itinerary.Name} của bạn.", fcmData);
        }

        public async Task<IEnumerable<ItineraryMemberDto>> GetMembersAsync(int itineraryId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Không tìm thấy lịch trình");

            var members = await _unitOfWork.ItineraryMembers.GetAllAsync(
                filter: im => im.ItineraryId == itineraryId && !im.DeleteFlag,
                includeProperties: "User"
            );

            return _mapper.Map<IEnumerable<ItineraryMemberDto>>(members);
        }

        public async Task LeaveItineraryAsync(int userId, int itineraryId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Không tìm thấy lịch trình");

            if (itinerary.UserId == userId)
            {
                throw new InvalidOperationException("Chủ lịch trình không thể rời khỏi lịch trình");
            }

            var member = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itineraryId && im.UserId == userId && !im.DeleteFlag, includeProperties: "User")
                ?? throw new ArgumentException("Người dùng không phải là thành viên của lịch trình này");
            member.DeleteFlag = true;
            _unitOfWork.ItineraryMembers.Update(member);

            // create notification for owner
            var notification = new Notification
            {
                UserId = itinerary.UserId,
                ItineraryId = itinerary.Id,
                Type = Constants.NotificationType_MemberLeft,
                Title = "Thành viên rời lịch trình",
                Message = $"Thành viên {member.User.Username} đã rời lịch trình {itinerary.Name}",
                CreatedAt = DateTime.UtcNow,
            };

            await _unitOfWork.Notifications.AddAsync(notification);
            await _unitOfWork.SaveChangesAsync();

            // Send notification to owner
            var fcmData = new Dictionary<string, string>
            {
                {"itineraryId", itinerary.Id.ToString() },
                {"type", Constants.NotificationType_MemberLeft },
            };

            await _fcmService.SendNotificationToUserAsync(itinerary.UserId,
                "Thành viên rời lịch trình",
                $"Thành viên {member.User.Username} đã rời lịch trình {itinerary.Name}",
                fcmData);
        }

        public async Task KickMemberAsync(int userId, int itineraryId, int memberId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Không tìm thấy lịch trình");

            var member = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itineraryId && im.Id == memberId && !im.DeleteFlag)
                ?? throw new ArgumentException("Không tìm thấy thành viên trong lịch trình này");
            member.DeleteFlag = true;
            _unitOfWork.ItineraryMembers.Update(member);

            // create notification for kicked member
            var notification = new Notification
            {
                UserId = member.UserId,
                ItineraryId = itinerary.Id,
                Type = Constants.NotificationType_MemberKicked,
                Title = "Bạn đã bị kick khỏi lịch trình",
                Message = $"Bạn đã bị kick khỏi lịch trình {itinerary.Name} bởi chủ lịch trình.",
                CreatedAt = DateTime.UtcNow,
            };
            await _unitOfWork.Notifications.AddAsync(notification);
            await _unitOfWork.SaveChangesAsync();

            // send notification to kicked member
            var fcmData = new Dictionary<string, string>
            {
                {"itineraryId", itinerary.Id.ToString() },
                {"type", Constants.NotificationType_MemberKicked },
            };
            await _fcmService.SendNotificationToUserAsync(member.UserId,
                "Bạn đã bị kick khỏi lịch trình",
                $"Bạn đã bị kick khỏi lịch trình {itinerary.Name} bởi chủ lịch trình.",
                fcmData);
        }

        public async Task<bool> IsOwnerAsync(int itineraryId, int userId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && i.UserId == userId);
            return itinerary is not null;
        }

        public async Task<bool> IsMemberAsync(int itineraryId, int userId)
        {
            return await _unitOfWork.ItineraryMembers.IsMemberAsync(itineraryId, userId);
        }
        public async Task<int> GetCurrentMemberCountAsync(int itineraryId)
        {
            return await _unitOfWork.ItineraryMembers.CountAsync(itineraryId);
        }
    }
}
