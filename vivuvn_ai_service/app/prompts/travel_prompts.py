"""
Travel planning prompts for ViVu Vietnam AI Service.

This module contains:
- SYSTEM_PROMPT: System instruction for Gemini with anti-hallucination rules
- create_user_prompt: Dynamic user prompt builder with grounded data
"""

from typing import Dict, List, Any, Optional

from fastapi.logger import logger
from app.api.schemas import TravelRequest
from app.models.weather_models import WeatherForecast
# Format with geographical clusters for better organization
from app.core.config import Settings
from app.utils.geo_utils import get_cluster_name, calculate_cluster_stats
from app.utils.weather_helpers import format_weather_for_prompt

# ============================================================================
# CORE PROMPT COMPONENTS - Modular & Composable
# ============================================================================

class PromptComponents:
    """Modular prompt sections that can be composed based on request."""
    
    CORE_RULES = """## NGUYÊN TẮC CỐT LÕI

### Grounding (CRITICAL - Chống Hallucination)
- CHỈ dùng địa điểm từ danh sách user prompt
- MỌI activity PHẢI có place_id hợp lệ
- KHÔNG tạo: sân bay, ga, khách sạn, nhà hàng generic, "Di chuyển", "Check-in", "Ăn sáng/trưa/tối"
- KHÔNG lặp lại các địa điểm trong lịch trình

### Schema - Activity (6 trường bắt buộc)
```json
{
  "time": "HH:MM",           // 24h format
  "name": "Tên từ danh sách", // Exact name
  "place_id": "ChIJ...",     // Google Place ID (BẮT BUỘC)
  "duration_hours": 1.5,     // 0.5-8.0
  "cost_estimate": 50000,    // VND, 0 nếu free
  "notes": "..."             // 15-30 từ tiếng Việt
}
```

### Transportation (CHỈ trong transportation_suggestions)
KHÔNG thêm vào activities | Tối đa 2 suggestions | Cost = TOTAL cho nhóm

**Sử dụng phương tiện từ yêu cầu của user (transportation_mode):**
- Gợi ý dựa CHÍNH XÁC trên phương tiện user chỉ định"""

    EXAMPLES_MINIMAL = """## VÍ DỤ CHUẨN

**Đền/Chùa (free):**
```json
{
  "time": "09:00",
  "name": "Chùa Một Cột",
  "place_id": "ChIJ7XWEcqGrNTERrsLf6W8259s",
  "duration_hours": 1.0,
  "cost_estimate": 0,
  "notes": "Biểu tượng Phật giáo Việt Nam, mặc lịch sự. Đẹp nhất buổi sáng sớm."
}
```

**Phiêu lưu (paid):**
```json
{
  "time": "08:00",
  "name": "Núi Fansipan",
  "place_id": "ChIJPWhb3k5ycTERkHYm-NE8qoA",
  "duration_hours": 5.0,
  "cost_estimate": 600000,
  "notes": "Nóc nhà Đông Dương, cáp treo hoặc trekking. Mang áo ấm, nhiệt độ đỉnh rất thấp."
}
```

**Đi lại giữa các thành phố (Transportation - max 2):**
```json
{
  "mode": "xe khách",
  "estimated_cost": 500000,
  "date": "2024-03-15",
  "details": "Hà Nội → Đà Nẵng, 07:00-21:00 (14h)"
}
```
*Format: Từ → Đến, giờ bắt đầu-giờ kết thúc (tổng thời gian). Max 150 ký tự. Không lặp lại route.*

Xem thêm: Bảo tàng, Biển, Thác, Chợ tại reference guide."""

    NOTES_GUIDE = """## VIẾT NOTES (BẮT BUỘC)

**Template:** [Đặc điểm nổi bật] + [Mẹo thực tế] (15-30 từ, tiếng Việt)

**Theo loại:**
- Đền/Chùa: Kiến trúc/tôn giáo + "Mặc lịch sự"
- Bảo tàng: Giá trị lịch sử + "Thuê guide"
- Núi/Thiên nhiên: Cảnh quan + "Áo ấm/giày thể thao"
- Biển: Chất lượng + "Kem chống nắng/đồ bơi"
- Thác/Mạo hiểm: Hoạt động + "Giày thể thao/quần áo dự phòng"
- Chợ: Đặc sản + "Mặc cả/cẩn thận tài sản"

✅ Tốt: "Nóc nhà Đông Dương, cáp treo hoặc trekking. Mang áo ấm."
❌ Tránh: "" / "Đẹp" / English / >50 từ"""

    PREFERENCES_GUIDE = """## SỞ THÍCH (BẮT BUỘC NẾU CÓ)

**Yêu cầu:** 60-70% activities khớp preferences

**Ánh xạ:**
- nature/thiên nhiên: Núi, thác, rừng, hang động, công viên quốc gia
- adventure/phiêu lưu: Zipline, trekking, leo núi, lặn, paragliding, cáp treo
- culture/văn hóa: Đền, chùa, làng nghề, hội làng, biểu diễn
- history/lịch sử: Bảo tàng, di tích, thành cổ, đài tưởng niệm
- food/ẩm thực: Chợ, phố ẩm thực, nhà hàng đặc sản
- beach/biển: Bãi biển, đảo, resort
- photography/nhiếp ảnh: View đẹp, sunrise/sunset, kiến trúc, ruộng bậc thang
- shopping/mua sắm: Chợ, trung tâm thương mại
- nightlife: Phố đi bộ, bar street, chợ đêm

**Ví dụ áp dụng:**
- ["nature", "adventure"] (6 acts) → 4: núi/thác/trek/zipline, 2: văn hóa/chợ
- ["culture", "history"] (6 acts) → 4-5: đền/chùa/bảo tàng, 1-2: ẩm thực
- ["food", "photography"] (5 acts) → 3-4: chợ/nhà hàng/view, 1-2: di tích"""

    SPECIAL_REQUIREMENTS_GUIDE = """## YÊU CẦU ĐẶC BIỆT (CONSTRAINT CỨNG)

**Priority:** special_requirements > preferences > geography > budget

**Xử lý theo loại:**

1. **Accessibility (khuyết tật/cao tuổi):**
   - LOẠI: Trekking, leo núi, nhiều cầu thang
   - ƯU TIÊN: Thang máy, cáp treo, đường phẳng
   - VD: Chùa Một Cột ✓ | Núi Fansipan trekking ✗

2. **Thời gian cụ thể:**
   - Chọn địa điểm mở cửa đúng giờ
   - Sáng: Chợ, biển, chùa, núi (bình minh)
   - Tối: Chợ đêm, phố đi bộ, show

3. **Gia đình trẻ em:**
   - LOẠI: Nguy hiểm, bar, trek dài
   - ƯU TIÊN: Công viên, biển, bảo tàng trẻ em
   - Duration dài hơn: 2-3h/activity

4. **Thể lực yếu:**
   - LOẠI: Trek >2h, leo núi, vận động nặng
   - ƯU TIÊN: Nhẹ nhàng, cáp treo thay leo bộ
   - Duration ngắn: 1-2h/activity

5. **Tôn giáo/văn hóa:**
   - KHÔNG loại địa điểm
   - THÊM notes cảnh báo phù hợp

**Flow:** Lọc không phù hợp → Chọn từ còn lại → Tối ưu geography/preferences"""

    WEATHER_PLANNING_RULES = """## QUY TẮC LẬP KẾ HOẠCH DỰA TRÊN THỜI TIẾT

**Khi có thông tin dự báo thời tiết, áp dụng các nguyên tắc sau:**

**Ngày mưa (lượng mưa >5mm):**
- ƯU TIÊN: Hoạt động trong nhà (bảo tàng, chùa có mái che, trung tâm thương mại, lớp nấu ăn, chợ có mái)
- TRÁNH: Bãi biển, leo núi, chụp ảnh ngoài trời, công viên, đạp xe
- GHI CHÚ: Đề xuất mang ô hoặc áo mưa

**Ngày nắng nóng (nhiệt độ chiều >32°C):**
- Lên lịch hoạt động ngoài trời vào BUỔI SÁNG (06:00-10:00) hoặc BUỔI CHIỀU (16:00-19:00)
- Lên lịch BUỔI TRƯA (11:00-15:00): Địa điểm có điều hòa (bảo tàng, trung tâm thương mại, quán cà phê)
- GHI CHÚ: Khuyến nghị kem chống nắng, uống đủ nước, che chắn

**Thời tiết đẹp (20-28°C, mưa <2mm):**
- TỐI ĐA HÓA hoạt động ngoài trời: tour thiên nhiên, bãi biển, leo núi, chụp ảnh, đạp xe
- Khuyến khích trải nghiệm ngoài trời cả ngày
- Thời điểm tốt nhất cho các địa điểm ngắm cảnh

**Tổng quát:**
- Tích hợp các mẹo liên quan đến thời tiết vào phần ghi chú của hoạt động
- Ví dụ: "Mang ô nếu trời mưa chiều", "Nên đi sớm để tránh nắng nóng"
- Ưu tiên sự an toàn và thoải mái của du khách"""

    BUDGET_STRATEGY = """## CHIẾN LƯỢC NGÂN SÁCH

**Tiers (VND/người/ngày):**
- **Tiết kiệm** (<500k): Max địa điểm free, tối đa 1-2 có phí thấp/ngày
- **Trung bình** (500k-1.5M): 50-60% free + 40-50% có phí (bảo tàng, di tích)
- **Thoải mái** (1.5M-3M): Hoạt động phí cao OK (cáp treo, tour đặc sắc)
- **Cao cấp** (>3M): Ưu tiên premium (zipline, helicopter, cruise)

**Cost estimates (VND per person):**
Đền/Chùa: 0-20k | Bảo tàng: 40-80k | Di tích: 50-120k | Phiêu lưu: 200-500k | Biển: 0-50k

**Formula:**
total_cost = sum(activities × group_size) + sum(transportation_total)
Transportation cost = TOTAL cho nhóm (đã tính group_size)

**Nếu vượt ngân sách:** schedule_unavailable=true, giải thích + đề xuất"""

    OPTIMIZATION_RULES = """## TỐI ƯU

**Địa lý:**
- Nhóm địa điểm gần nhau cùng ngày
- Sắp xếp theo tọa độ tránh đi lại
- 0.01° ≈ 1.1km, di chuyển 15-20 phút/5km
- Buffer 30-45 phút giữa activities >5km (KHÔNG tính trong duration)

**Thời gian:**
Đền/Chùa: 0.5-1.5h | Bảo tàng: 1.5-2.5h | Di tích: 1.5-3h | Biển: 2-4h | Núi: 2-5h

**Lịch mẫu:**
09:00-10:30 Điểm 1 → 11:00-12:30 Điểm 2 → [Trưa] → 13:30-15:30 Điểm 3 → 16:00-18:00 Điểm 4"""

    VALIDATION_AND_FALLBACK = """## VALIDATION & FALLBACK

**Validation rules:**
- Min 3 activities/day
- place_id hợp lệ từ danh sách
- total_cost ≤ budget × 1.1 (10% buffer OK)

**Fallback strategies:**
1. **Thiếu địa điểm:** Giảm số ngày, note "Chỉ đủ cho X ngày chất lượng"
2. **Zero preference match:** Dùng rating cao nhất + notes giải thích
3. **Budget impossible:** schedule_unavailable + "Tối thiểu cần Xk VND"
4. **Không đủ hoạt động/ngày:** Tăng duration_hours cho activities hiện có

**Output:** JSON theo schema TravelItinerary | MỌI text tiếng Việt"""


# ============================================================================
# SYSTEM PROMPT BUILDER - Adaptive & Token-Efficient
# ============================================================================

def build_system_prompt(
    has_preferences: bool = False,
    has_special_requirements: bool = False,
    include_full_examples: bool = False
) -> str:
    """
    Build adaptive system prompt based on request characteristics.
    
    Args:
        has_preferences: Whether user specified preferences
        has_special_requirements: Whether user has special requirements
        include_full_examples: Whether to include all 7 examples (normally just 2)
    
    Returns:
        Optimized system prompt string
    """
    
    components = [
        "# CHUYÊN GIA LẬP KẾ HOẠCH DU LỊCH VIỆT NAM\n",
        "Tạo lịch trình CHÍNH XÁC từ danh sách địa điểm user prompt.\n",
        PromptComponents.CORE_RULES,
        "\n",
        PromptComponents.EXAMPLES_MINIMAL,
        "\n",
        PromptComponents.NOTES_GUIDE,
    ]
    
    # Conditional sections based on request
    if has_preferences:
        components.append("\n")
        components.append(PromptComponents.PREFERENCES_GUIDE)

    if has_special_requirements:
        components.append("\n")
        components.append(PromptComponents.SPECIAL_REQUIREMENTS_GUIDE)

    # Always include weather planning rules
    components.append("\n")
    components.append(PromptComponents.WEATHER_PLANNING_RULES)

    # Always include budget strategy and optimization
    components.append("\n")
    components.append(PromptComponents.BUDGET_STRATEGY)
    components.append("\n")
    components.append(PromptComponents.OPTIMIZATION_RULES)
    components.append("\n")
    components.append(PromptComponents.VALIDATION_AND_FALLBACK)
    
    return "".join(components)


# ============================================================================
# USER PROMPT BUILDER - Token-Optimized
# ============================================================================

def create_user_prompt(
    travel_request: TravelRequest,  # TravelRequest type
    relevant_places: List[Dict[str, Any]],
    place_clusters: Optional[List[List[Dict[str, Any]]]] = None,
    top_relevant_places: Optional[List[Dict[str, Any]]] = None,
    weather_forecast: Optional[WeatherForecast] = None
) -> str:
    """
    Build token-optimized user prompt with grounded data.

    Optimizations applied:
    - Reduced coordinate precision: 4 → 2 decimals (saves ~10 chars/place)
    - Removed unnecessary backticks and formatting
    - Conditional descriptions only for top 3 places
    - Compact cluster info format
    - Smart truncation based on duration

    Token reduction: ~30-40% vs original

    Args:
        travel_request: User's travel request
        relevant_places: Verified places from search (geographically ordered)
        place_clusters: Optional geographical clusters
        top_relevant_places: Top places by relevance score
        weather_forecast: Optional weather forecast for the trip

    Returns:
        Token-efficient prompt with grounded data
    """
    
    config = Settings()

    # Calculate key metrics
    duration = (travel_request.end_date - travel_request.start_date).days + 1
    preferences_str = ", ".join(travel_request.preferences) if travel_request.preferences else "tham quan chung"
    
    # Build set of top place_ids for detailed descriptions (only top 3)
    top_place_ids = set()
    if top_relevant_places:
        for place in top_relevant_places[:config.TOP_PLACES_WITH_DESCRIPTION]:
            place_id = place.get('metadata', {}).get('place_id')
            if place_id:
                top_place_ids.add(place_id)
    
    # BUILD PLACES CONTEXT (Token-optimized)
    places_context = "## 📍 DANH SÁCH ĐỊA ĐIỂM\n\n"
    
    if not relevant_places:
        places_context += "⚠️ KHÔNG TÌM THẤY - Thông báo user tinh chỉnh.\n"
    
    elif place_clusters and len(place_clusters) > 1:
        places_context += f"**{len(place_clusters)} KHU VỰC địa lý:**\n\n"
        
        # Calculate global center for naming (reuse existing function if available)
        all_coords = [
            (p['metadata']['latitude'], p['metadata']['longitude'])
            for p in relevant_places
            if p.get('metadata', {}).get('latitude') and p.get('metadata', {}).get('longitude')
        ]
        
        global_center = None
        if all_coords:
            global_center = (
                sum(lat for lat, _ in all_coords) / len(all_coords),
                sum(lng for _, lng in all_coords) / len(all_coords)
            )
        
        place_counter = 0
        for cluster_idx, cluster in enumerate(place_clusters):
            # Use external function if available, else simple naming
            try:
                cluster_name = get_cluster_name(cluster, cluster_idx, len(place_clusters), global_center)
                cluster_stats = calculate_cluster_stats(cluster)
            except ImportError:
                cluster_name = f"Khu vực {cluster_idx + 1}"
                # Simple stats calculation
                cluster_lats = [p['metadata']['latitude'] for p in cluster]
                cluster_lngs = [p['metadata']['longitude'] for p in cluster]
                cluster_stats = {
                    'center_lat': sum(cluster_lats) / len(cluster_lats),
                    'center_lng': sum(cluster_lngs) / len(cluster_lngs),
                    'radius_km': 0  # Simplified
                }
            
            places_context += f"\n### {cluster_name}\n"
            # Compact cluster info - reduced precision saves tokens
            places_context += f"📍 ({cluster_stats['center_lat']:.{config.COORD_DECIMAL_PLACES}f}°, {cluster_stats['center_lng']:.{config.COORD_DECIMAL_PLACES}f}°)"
            if cluster_stats.get('radius_km', 0) > 0:
                places_context += f" | ~{cluster_stats['radius_km']:.1f}km"
            places_context += "\n\n"

            for place in cluster:
                place_counter += 1
                meta = place.get('metadata', {})
                
                # Reduced precision: 2 decimals = ~1.1km accuracy (sufficient)
                lat = meta.get('latitude', 0)
                lng = meta.get('longitude', 0)
                rating = meta.get('rating', 'N/A')
                
                # Compact format - removed unnecessary chars
                places_context += (
                    f"**{place_counter}. {meta.get('name', 'N/A')}**\n"
                    f"   • place_id: {meta.get('place_id', 'N/A')}\n"  # Removed backticks
                    f"   • ({lat:.{config.COORD_DECIMAL_PLACES}f}°, {lng:.{config.COORD_DECIMAL_PLACES}f}°) | ⭐{rating}\n"
                )
                
                # Conditional description - only top 3 to save tokens
                if meta.get('place_id') in top_place_ids and meta.get('chunk_text'):
                    desc = meta.get('chunk_text')[:config.DESCRIPTION_MAX_LENGTH]
                    places_context += f"   • {desc}...\n"
                places_context += "\n"
        
        # Compact instruction
        if len(place_clusters) > 1:
            places_context += f"💡 {duration} ngày, {len(place_clusters)} khu vực → 1-2 khu/ngày, sắp xếp theo tọa độ\n\n"
    
    else:
        # Linear list (no clusters) - same optimizations
        for i, place in enumerate(relevant_places, 1):
            meta = place.get('metadata', {})
            lat = meta.get('latitude', 0)
            lng = meta.get('longitude', 0)
            rating = meta.get('rating', 'N/A')
            
            places_context += (
                f"**{i}. {meta.get('name', 'N/A')}**\n"
                f"   • place_id: {meta.get('place_id', 'N/A')}\n"
                f"   • ({lat:.{config.COORD_DECIMAL_PLACES}f}°, {lng:.{config.COORD_DECIMAL_PLACES}f}°) | ⭐{rating}\n"
            )
            if meta.get('place_id') in top_place_ids and meta.get('chunk_text'):
                places_context += f"   • {meta.get('chunk_text')[:config.DESCRIPTION_MAX_LENGTH]}...\n"
            places_context += "\n"
    
    # Data sufficiency note (compact)
    if len(relevant_places) < config.MIN_ACTIVITIES_PER_DAY * duration:
        places_context += f"⚠️ {len(relevant_places)} địa điểm - có thể cần giảm số ngày\n"
    
    # CALCULATE BUDGET TIER - documented thresholds
    budget_per_person_per_day = travel_request.budget / (travel_request.group_size * duration)
    
    if budget_per_person_per_day < config.BUDGET_TIER_ECONOMY:
        budget_tier = "Tiết kiệm"
        budget_strategy = "Max địa điểm free"
    elif budget_per_person_per_day < config.BUDGET_TIER_MID_RANGE:
        budget_tier = "Trung bình"
        budget_strategy = "Cân bằng free + có phí"
    elif budget_per_person_per_day < config.BUDGET_TIER_COMFORT:
        budget_tier = "Thoải mái"
        budget_strategy = "Trải nghiệm đặc sắc OK"
    else:
        budget_tier = "Cao cấp"
        budget_strategy = "Ưu tiên premium/unique"
    
    # BUILD FINAL PROMPT (compact format)
    special_reqs = ""
    if travel_request.special_requirements:
        special_reqs = (
            f"⚠️ YÊU CẦU ĐẶC BIỆT (CONSTRAINT CỨNG):\n"
            f"{travel_request.special_requirements}\n"
            f"→ Lọc địa điểm không phù hợp, ưu tiên > preferences/geography\n"
        )

    # Add weather information if available

    transportation_info = ""
    if travel_request.transportation_mode:
        transportation_info = f"🚗 Phương tiện di chuyển: {travel_request.transportation_mode}\n"


    weather_section = ""
    if weather_forecast:
        formatted_weather = format_weather_for_prompt(weather_forecast)
        if formatted_weather:
            weather_section = f"\n{formatted_weather}\n"

    # Compact header
    return f"""## NHIỆM VỤ
Tạo lịch {duration} ngày {travel_request.destination}, CHỈ dùng địa điểm danh sách.

## THÔNG TIN
{travel_request.origin or 'N/A'} → {travel_request.destination}
{travel_request.start_date.strftime('%d/%m/%Y')} - {travel_request.end_date.strftime('%d/%m/%Y')} ({duration} ngày)
👥 {travel_request.group_size} người
🎯 Sở thích: {preferences_str} {"⚠️ 60-70% activities phải khớp" if travel_request.preferences else ""}
💰 {travel_request.budget:,.0f} VND (≈{budget_per_person_per_day:,.0f} VND/người/ngày)
💼 TIER: {budget_tier} → {budget_strategy}
{transportation_info}{special_reqs}{weather_section}
{places_context}

## YÊU CẦU
1. Activity có place_id chính xác từ danh sách
2. Nhóm cùng khu vực/ngày, sắp xếp tọa độ
3. Transportation: CHỈ trong transportation_suggestions, max 2
4. Nếu cost > {travel_request.budget:,.0f}: schedule_unavailable=true
5. Notes: sử dụng tiếng Việt, theo template

**JSON schema TravelItinerary**"""


# ============================================================================
# CONVENIENCE FUNCTIONS
# ============================================================================

def get_system_prompt_for_request(travel_request: TravelRequest) -> str:
    """
    Get optimized system prompt tailored to the specific request.
    
    This is the main function to use in production - it automatically
    determines which sections to include based on the request.
    
    Args:
        travel_request: TravelRequest object
    
    Returns:
        Optimized system prompt (800-1,650 tokens vs old 4,500 tokens)
    """
    has_prefs = bool(travel_request.preferences and len(travel_request.preferences) > 0)
    has_special = bool(travel_request.special_requirements and travel_request.special_requirements.strip())
    
    return build_system_prompt(
        has_preferences=has_prefs,
        has_special_requirements=has_special,
        include_full_examples=False  # Keep minimal for token efficiency
    )

__all__ = ["get_system_prompt_for_request", "create_user_prompt"]
