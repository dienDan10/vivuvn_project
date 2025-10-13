"""
Travel planning prompts for ViVu Vietnam AI Service.

This module contains:
- SYSTEM_PROMPT: System instruction for Gemini with anti-hallucination rules
- create_user_prompt: Dynamic user prompt builder with grounded data
"""

from typing import Dict, List, Any
from app.api.schemas import TravelRequest


# ============================================================================
# SYSTEM PROMPT - With Anti-Hallucination Instructions
# ============================================================================


SYSTEM_PROMPT = """Bạn là chuyên gia lập kế hoạch du lịch Việt Nam tạo lịch trình từ dữ liệu có sẵn.

## NGUYÊN TẮC TUYỆT ĐỐI
1. ✓ MỖI hoạt động PHẢI tham chiếu địa điểm từ "Danh sách địa điểm" bên dưới
2. ✗ KHÔNG tạo hoạt động nếu không có địa điểm tương ứng trong danh sách
3. ✗ KHÔNG thêm: sân bay, nhà ga, điểm trung chuyển, hoặc địa điểm di chuyển
4. ⚠️ Ít địa điểm = ít hoạt động (chất lượng > số lượng)

## HOẠT ĐỘNG CHO PHÉP
### ✅ Tạo từ dữ liệu (from_database: true)
- Địa điểm du lịch với place_id từ danh sách
- Tất cả phải có đầy đủ: name, place_id, mô tả từ DB

### ⛔ TUYỆT ĐỐI KHÔNG TẠO
- Hoạt động sân bay/nhà ga (đã có trong transportation_suggestions)
- "Di chuyển đến...", "Check-in chuyến bay", "Ra sân bay"
- Bất kỳ hoạt động di chuyển nào (inter-city/intra-city)
- Địa điểm không có trong danh sách DB

## ĐỊNH DẠNG JSON BẮT BUỘC
```json
{
  "days": [
    {
      "day": 1,
      "date": "2024-03-15",
      "activities": [
        {
          "time": "09:00",
          "name": "Tham quan Chùa Một Cột",
          "place_id": "ChIJxxx",
          "duration_hours": 1.5,
          "cost_estimate": 50000,
          "category": "culture",
          "from_database": true
        }
      ],
      "estimated_cost": 500000,
      "notes": "Mang nước và kem chống nắng"
    }
  ],
  "total_cost": 1500000,
  "places_used_count": 8,
  "transportation_suggestions": [
    {
      "route": "Hà Nội → Đà Nẵng",
      "method": "máy bay",
      "duration_hours": 1.5,
      "cost_estimate": 1200000
    }
  ],
  "schedule_unavailable": false,
  "unavailable_reason": null
}
**KIỂM SOÁT NGÂN SÁCH**
    - Tính total_cost khi xây dựng lịch trình
    - Nếu total_cost > budget:
        - schedule_unavailable: true
        - unavailable_reason: "Chi phí ước tính [X] VND vượt ngân sách [Y] VND"
    - Vẫn trả về lịch trình đầy đủ để người dùng xem và điều chỉnh
**QUY TẮC CATEGORY**
food, sightseeing, culture, history, nature, adventure, shopping, entertainment, relaxation
- Ưu tiên category chính của địa điểm
- Nếu mơ hồ: chọn theo mục đích chính (ví dụ: chùa → culture)

TẤT CẢ MÔ TẢ VÀ GHI CHÚ BẰNG TIẾNG VIỆT."""


# ============================================================================
# USER PROMPT BUILDER - Provides grounded data
# ============================================================================

def create_user_prompt(
    travel_request: TravelRequest,
    relevant_places: List[Dict[str, Any]]
) -> str:
    """
    Build user prompt with grounded data from vector search.

    Args:
        travel_request: User's travel request with destination, dates, preferences
        relevant_places: List of verified places from Pinecone search

    Returns:
        Token-efficient prompt with strict grounding instructions
    """

    duration = (travel_request.end_date - travel_request.start_date).days + 1
    preferences_str = ", ".join(travel_request.preferences) if travel_request.preferences else "tham quan chung"

    # Token-efficient place listing - only essential fields
    places_context = "## Danh sách địa điểm (CHỈ SỬ DỤNG CÁC ĐỊA ĐIỂM NÀY):\n\n"

    if not relevant_places:
        places_context += "⚠️ Không tìm thấy địa điểm. Thông báo người dùng tinh chỉnh tìm kiếm.\n"
    else:
        for i, place in enumerate(relevant_places[:20], 1):
            meta = place.get('metadata', {})
            places_context += (
                f"{i}. {meta.get('name', 'N/A')} | "
                f"place_id: {meta.get('place_id', 'N/A')} | "
                f"Tỉnh: {meta.get('province', 'N/A')} | "
                f"Rating: {meta.get('rating', 'N/A')}\n"
            )
            # Only add description if it exists and is meaningful
            if meta.get('chunk_text'):
                places_context += f"   → {meta.get('chunk_text')[:200]}...\n"

        # Add data sufficiency warning
        if len(relevant_places) < 5:
            places_context += f"\n⚠️ Chỉ {len(relevant_places)} địa điểm - tạo lịch trình ngắn gọn, chất lượng cao.\n"

    special_reqs = f"- Yêu cầu đặc biệt: {travel_request.special_requirements}\n" if travel_request.special_requirements else ""

    return f"""Tạo lịch trình {duration} ngày cho {travel_request.destination}.

## Thông tin chuyến đi:
- Từ: {travel_request.origin} → Đến: {travel_request.destination}
- Ngày: {travel_request.start_date.strftime('%d/%m/%Y')} - {travel_request.end_date.strftime('%d/%m/%Y')}
- Số người: {travel_request.group_size} | Sở thích: {preferences_str}
- Ngân sách: {travel_request.budget} VND
{special_reqs}
{places_context}

## Yêu cầu xây dựng lịch trình:

### 1. HOẠT ĐỘNG
- Mỗi hoạt động PHẢI khớp với 1 địa điểm từ danh sách trên (dùng chính xác place_id)
- KHÔNG thêm: sân bay, ga, điểm trung chuyển, hoạt động di chuyển

### 2. DI CHUYỂN
- Chỉ thêm vào transportation_suggestions (không phải activities)
- Route: {travel_request.origin} → {travel_request.destination} (và ngược lại)
- Phương tiện: chỉ chọn từ [máy bay, ô tô, xe máy]
- Tối đa 2 gợi ý (lượt đi + lượt về)

### 3. NGÂN SÁCH
- Tính total_cost = tổng estimated_cost các ngày
- Nếu total_cost > {travel_request.budget}:
  - schedule_unavailable: true
  - unavailable_reason: nêu rõ chênh lệch và đề xuất
  - Vẫn trả về lịch trình đầy đủ

### 4. ĐỊNH DẠNG JSON
Mỗi activity PHẢI có đủ 7 trường:
- time (HH:MM), name, place_id, duration_hours, cost_estimate, category, from_database

TRẢ VỀ JSON HOÀN CHỈNH BẰNG TIẾNG VIỆT."""


__all__ = ["SYSTEM_PROMPT", "create_user_prompt"]
