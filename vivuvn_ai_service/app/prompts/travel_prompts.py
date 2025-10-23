"""
Travel planning prompts for ViVu Vietnam AI Service.

This module contains:
- SYSTEM_PROMPT: System instruction for Gemini with anti-hallucination rules
- create_user_prompt: Dynamic user prompt builder with grounded data
"""

from typing import Dict, List, Any
from app.api.schemas import TravelRequest
# Format with geographical clusters for better organization
from app.utils.geo_utils import get_cluster_name, calculate_cluster_stats


# ============================================================================
# SYSTEM PROMPT - With Anti-Hallucination Instructions
# ============================================================================


SYSTEM_PROMPT = """Bạn là chuyên gia lập kế hoạch du lịch Việt Nam. Tạo lịch trình CHÍNH XÁC từ danh sách địa điểm trong user prompt.

## NGUYÊN TẮC BẮT BUỘC

### 1. Grounding (Chống Hallucination)
- CHỈ sử dụng địa điểm từ danh sách trong user prompt
- MỌI activity PHẢI có place_id chính xác từ danh sách
- KHÔNG tạo địa điểm mới, sân bay, ga, khách sạn, điểm ăn uống chung chung
- KHÔNG tạo hoạt động "Di chuyển", "Check-in", "Ăn sáng/trưa/tối", "Nghỉ ngơi"

### 2. Schema - Activity (6 trường bắt buộc)
- time: "HH:MM" (24h format)
- name: tên chính xác từ danh sách
- place_id: Google Place ID (BẮT BUỘC)
- duration_hours: 0.5-8.0
- cost_estimate: VND (0 nếu miễn phí)
- category: culture|history|nature|photography|food|shopping|adventure|relaxation|nightlife

### 3. Transportation (CHỈ vào transportation_suggestions, KHÔNG activities)

Chọn mode theo DECISION TREE:
- 50-100km: xe khách (giá rẻ, linh hoạt)
- 100-300km:
  • Nếu budget < 3M: xe khách
  • Nếu scenic route (Đà Nẵng↔Huế, HN↔Lào Cai): tàu hỏa
  • Else: xe khách
- 300-400km:
  • Nếu duration ≤ 2 ngày: máy bay (save time)
  • Else: tàu hỏa (comfortable, scenic)
- >400km: máy bay (always)
- Nhóm ≥4 người + nhiều điểm dừng: ô tô cá nhân (any distance)

Tối đa 2 suggestions (lượt đi + về) | Cost = TOTAL cho nhóm | Schema: mode, estimated_cost, date, details

## VÍ DỤ CHUẨN

Activity hợp lệ:
{"time":"09:00","name":"Chùa Một Cột","place_id":"ChIJAbc123","duration_hours":1.0,"cost_estimate":0,"category":"culture"}

Budget vượt quá:
{"schedule_unavailable":true,"unavailable_reason":"Chi phí 8.5M vượt ngân sách 5M. Đề xuất: tăng thêm 3.5M hoặc giảm xuống 3 ngày","days":[],"total_cost":0}

## TỐI ƯU ĐỊA LÝ

1. Nhóm địa điểm gần nhau cùng ngày (ưu tiên clusters nếu có)
2. Sắp xếp hoạt động theo tọa độ, tránh đi lại
3. Ước tính: 0.01° ≈ 1.1km, di chuyển 15-20 phút/5km
4. Buffer time: 30-45 phút giữa activities cách >5km (KHÔNG tính trong duration_hours, để riêng)

## NGÂN SÁCH

Cost estimate (VND, PER-PERSON basis):
Đền/Chùa 0-20k (most free) | Bảo tàng 40-80k | Di tích 50-120k | Phiêu lưu 200-500k | Bãi biển 0-50k (entrance only)

Formula: total_cost = sum(activities.cost_estimate × group_size) + sum(transportation.estimated_cost)
Transportation cost = TOTAL cho cả nhóm (đã tính group_size)

Nếu total_cost > budget → schedule_unavailable: true, giải thích và đề xuất

## THỜI GIAN

Duration: Đền/Chùa 0.5-1.5h, Bảo tàng 1.5-2.5h, Di tích 1.5-3h, Công viên 1-2h, Biển 2-4h, Núi 2-5h, Mua sắm 1.5-3h

Lịch mẫu: 09:00-10:30 Điểm 1 → 11:00-12:30 Điểm 2 → [Trưa] → 13:30-15:30 Điểm 3 → 16:00-18:00 Điểm 4

## CATEGORY (Decision Logic)

Chọn category theo thứ tự ưu tiên:
1. **Mục đích chính**: Chùa/đền tôn giáo → culture | Di tích chiến tranh → history | Hang động/thác → nature
2. **Nếu overlap**: Văn hóa > Lịch sử > Tự nhiên > Photography
3. **Fallback**: Không rõ → photography

Định nghĩa:
culture: Chùa đền văn hóa (religious/artistic) | history: Di tích lịch sử (>100 năm, war sites) | nature: Núi rừng thác hang (natural formations) | photography: Viewpoint phố cổ (scenic beauty primary) | food: Chợ ẩm thực khu ăn | shopping: TTTM chợ mua sắm | adventure: Leo núi lặn mạo hiểm | relaxation: Spa resort bãi biển yên tĩnh | nightlife: Bar club chợ đêm

## OUTPUT

Trả JSON theo schema TravelItinerary. Nếu thiếu địa điểm cho N ngày, tạo ít ngày hơn với chất lượng cao.

**MỌI mô tả và notes BẰNG TIẾNG VIỆT.**"""


# ============================================================================
# USER PROMPT BUILDER - Provides grounded data
# ============================================================================

def create_user_prompt(
    travel_request: TravelRequest,
    relevant_places: List[Dict[str, Any]],
    place_clusters: List[List[Dict[str, Any]]] = None
) -> str:
    """
    Build user prompt with grounded data from vector search.

    Args:
        travel_request: User's travel request with destination, dates, preferences
        relevant_places: List of verified places from Pinecone search
        place_clusters: Optional geographical clusters for better organization

    Returns:
        Token-efficient prompt with strict grounding instructions and cluster-aware hints
    """

    duration = (travel_request.end_date - travel_request.start_date).days + 1
    preferences_str = ", ".join(travel_request.preferences) if travel_request.preferences else "tham quan chung"

    # Dynamic place limit based on duration (optimize token usage)
    # Formula: min(available_places, max(12, duration * 4))
    max_places_in_prompt = min(len(relevant_places), max(12, duration * 4))

    # Show full descriptions only for top N most relevant places (save tokens)
    detailed_description_limit = min(8, max(5, duration * 2))

    # BUILD PLACES CONTEXT
    places_context = "## 📍 DANH SÁCH ĐỊA ĐIỂM (Database đã xác minh)\n\n"

    if not relevant_places:
        places_context += "⚠️ **KHÔNG TÌM THẤY ĐỊA ĐIỂM** - Thông báo người dùng tinh chỉnh tìm kiếm.\n"

    elif place_clusters and len(place_clusters) > 1:
        places_context += f"**Các địa điểm đã được nhóm thành {len(place_clusters)} KHU VỰC địa lý:**\n\n"

        # Calculate global center for accurate geographical naming
        all_coords = [(p['metadata']['latitude'], p['metadata']['longitude'])
                      for p in relevant_places
                      if p.get('metadata', {}).get('latitude') and p.get('metadata', {}).get('longitude')]

        global_center = None
        if all_coords:
            global_center = (
                sum(lat for lat, _ in all_coords) / len(all_coords),
                sum(lng for _, lng in all_coords) / len(all_coords)
            )

        place_counter = 0
        for cluster_idx, cluster in enumerate(place_clusters):
            if place_counter >= max_places_in_prompt:
                break

            cluster_name = get_cluster_name(cluster, cluster_idx, len(place_clusters), global_center)
            cluster_stats = calculate_cluster_stats(cluster)

            places_context += f"\n### {cluster_name}\n"
            # Simplified cluster info - removed verbose metadata
            places_context += f"📍 Tọa độ trung tâm: ({cluster_stats['center_lat']:.4f}°, {cluster_stats['center_lng']:.4f}°) | Bán kính ~{cluster_stats['radius_km']:.1f}km\n\n"

            for place in cluster:
                if place_counter >= max_places_in_prompt:
                    break
                place_counter += 1
                meta = place.get('metadata', {})

                lat, lng = meta.get('latitude', 0), meta.get('longitude', 0)
                rating = meta.get('rating', 'N/A')

                places_context += (
                    f"**{place_counter}. {meta.get('name', 'N/A')}**\n"
                    f"   • place_id: `{meta.get('place_id', 'N/A')}`\n"
                    f"   • Tọa độ: ({lat:.4f}°, {lng:.4f}°) | Rating: {rating}\n"
                )

                # Only show description for top N places (save tokens)
                if place_counter <= detailed_description_limit and meta.get('chunk_text'):
                    places_context += f"   • Mô tả: {meta.get('chunk_text')[:150]}...\n"
                places_context += "\n"

        # Simplified cluster instruction
        places_context += f"\n💡 {duration} ngày, {len(place_clusters)} khu vực → ưu tiên 1-2 khu vực/ngày, sắp xếp theo tọa độ gần nhau\n\n"

    else:
        # Linear list (no clusters or only 1 cluster)
        for i, place in enumerate(relevant_places[:max_places_in_prompt], 1):
            meta = place.get('metadata', {})
            lat, lng = meta.get('latitude', 0), meta.get('longitude', 0)
            rating = meta.get('rating', 'N/A')

            places_context += (
                f"**{i}. {meta.get('name', 'N/A')}**\n"
                f"   • place_id: `{meta.get('place_id', 'N/A')}`\n"
                f"   • Tọa độ: ({lat:.4f}°, {lng:.4f}°) | Rating: {rating}\n"
            )
            # Only show description for top N places
            if i <= detailed_description_limit and meta.get('chunk_text'):
                places_context += f"   • Mô tả: {meta.get('chunk_text')[:150]}...\n"
            places_context += "\n"

    # Data sufficiency note (compact)
    if len(relevant_places) < 5:
        places_context += f"\n⚠️ Chỉ {len(relevant_places)} địa điểm - tạo lịch ngắn gọn\n"
    elif max_places_in_prompt < len(relevant_places):
        places_context += f"\nHiển thị {max_places_in_prompt}/{len(relevant_places)} địa điểm phù hợp nhất\n"

    # BUILD FINAL PROMPT (compact format)
    special_reqs = f"Ưu tiên các địa điểm và khoảng thời gian thỏa mãn yêu cầu đặc biệt: {travel_request.special_requirements}\n" if travel_request.special_requirements else ""

    return f"""## NHIỆM VỤ
Tạo lịch {duration} ngày cho {travel_request.destination}, CHỈ dùng địa điểm từ danh sách bên dưới.

## THÔNG TIN
Tuyến: {travel_request.origin or 'N/A'} → {travel_request.destination}
Thời gian: {travel_request.start_date.strftime('%d/%m/%Y')} - {travel_request.end_date.strftime('%d/%m/%Y')} ({duration} ngày)
Số người: {travel_request.group_size} | Sở thích: {preferences_str}
Ngân sách: {travel_request.budget:,.0f} VND
{special_reqs}
{places_context}

## YÊU CẦU
1. MỖI activity khớp 1 địa điểm từ danh sách (có place_id chính xác)
2. Nhóm địa điểm cùng khu vực/ngày, sắp xếp theo tọa độ
3. Transportation: CHỈ thêm vào transportation_suggestions (KHÔNG activities), tối đa 2
4. Nếu total_cost > {travel_request.budget:,.0f}: set schedule_unavailable=true, giải thích unavailable_reason
5. Activity: 6 trường (time, name, place_id, duration_hours, cost_estimate, category) - KHÔNG có from_database

**TRẢ JSON theo schema TravelItinerary**"""


__all__ = ["SYSTEM_PROMPT", "create_user_prompt"]
