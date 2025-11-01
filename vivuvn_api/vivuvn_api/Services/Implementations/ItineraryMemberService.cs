using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryMemberService(ITokenService _tokenService, IUnitOfWork _unitOfWork, IMapper _mapper) : IItineraryMemberService
    {
        public async Task<InviteCodeDto> GenerateInviteCodeAsync(int itineraryId, int ownerId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Itinerary not found");

            if (itinerary.UserId != ownerId)
            {
                throw new UnauthorizedAccessException("Only the itinerary owner can generate invite codes");
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
                ?? throw new ArgumentException("Invalid invite code");

            // check if user is already a member
            var existingMember = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itinerary.Id && im.UserId == userId);

            if (existingMember is not null && !existingMember.DeleteFlag) // active member exists
            {
                throw new BadHttpRequestException("User is already a member of this itinerary");
            }

            if (existingMember is not null && existingMember.DeleteFlag) // inactive member exists
            {
                existingMember.DeleteFlag = false;
                _unitOfWork.ItineraryMembers.Update(existingMember);
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // add new member
            var newMember = new ItineraryMember
            {
                UserId = userId,
                ItineraryId = itinerary.Id,
                JoinedAt = DateTime.UtcNow,
                DeleteFlag = false
            };
            await _unitOfWork.ItineraryMembers.AddAsync(newMember);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<ItineraryMemberDto>> GetMembersAsync(int itineraryId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Itinerary not found");

            var members = await _unitOfWork.ItineraryMembers.GetAllAsync(
                filter: im => im.ItineraryId == itineraryId && !im.DeleteFlag,
                includeProperties: "User"
            );

            return _mapper.Map<IEnumerable<ItineraryMemberDto>>(members);
        }

        public async Task LeaveItineraryAsync(int userId, int itineraryId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Itinerary not found");

            var member = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itineraryId && im.UserId == userId && !im.DeleteFlag)
                ?? throw new ArgumentException("User is not a member of this itinerary");
            member.DeleteFlag = true;
            _unitOfWork.ItineraryMembers.Update(member);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task KickMemberAsync(int userId, int itineraryId, int memberId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Itinerary not found");
            if (itinerary.UserId != userId)
            {
                throw new UnauthorizedAccessException("Only the itinerary owner can kick members");
            }
            var member = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itineraryId && im.UserId == memberId && !im.DeleteFlag)
                ?? throw new ArgumentException("Member not found in this itinerary");
            member.DeleteFlag = true;
            _unitOfWork.ItineraryMembers.Update(member);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}
