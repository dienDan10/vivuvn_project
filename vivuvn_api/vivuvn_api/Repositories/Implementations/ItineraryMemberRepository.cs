﻿using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryMemberRepository : Repository<ItineraryMember>, IItineraryMemberRepository
    {
        public ItineraryMemberRepository(AppDbContext context) : base(context)
        {
        }
    }
}
