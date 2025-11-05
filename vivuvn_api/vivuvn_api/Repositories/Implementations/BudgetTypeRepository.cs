using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class BudgetTypeRepository : Repository<BudgetType>, IBudgetTypeRepository
    {
        public BudgetTypeRepository(AppDbContext context) : base(context)
        {
        }
    }
}
