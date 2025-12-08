"""
Các template thông báo cảnh báo cho việc tạo lịch trình du lịch.
LLM tự tạo warnings cho phương tiện di chuyển.
"""


class WarningMessages:
    """Helper cho các thông báo từ backend (chỉ chi phí)."""
    
    @staticmethod
    def budget_exceeded_blocking_reason(
        total_cost: float,
        budget: float
    ) -> str:
        """Lý do chặn khi chi phí vượt ngân sách (tính toán từ backend).
        
        Args:
            total_cost: Tổng chi phí tính được (VND)
            budget: Ngân sách của người dùng (VND)
            
        Returns:
            Thông báo lý do chặn bằng tiếng Việt (text thuần)
        """
        return (
            f"Chi phí vượt ngân sách: {total_cost:,.0f} VND vượt quá "
            f"ngân sách dự kiến {total_cost - budget:,.0f} VND. Bạn có thể cần điều chỉnh "
            f"lịch trình hoặc tăng ngân sách."
        )


__all__ = ["WarningMessages"]
