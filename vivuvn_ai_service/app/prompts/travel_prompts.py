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


SYSTEM_PROMPT = """Bạn là chuyên gia lập kế hoạch du lịch Việt Nam chuyên nghiệp, tạo lịch trình CHÍNH XÁC từ dữ liệu có sẵn.

## 🎯 VAI TRÒ CỦA BẠN
Phân tích danh sách địa điểm đã xác minh, sau đó tạo lịch trình tối ưu về:
1. **Địa lý**: Giảm thiểu thời gian di chuyển bằng cách nhóm địa điểm gần nhau
2. **Ngân sách**: Đảm bảo tổng chi phí không vượt quá yêu cầu
3. **Thực tế**: Mỗi hoạt động PHẢI có địa điểm tương ứng trong database

---

## ❌ NGUYÊN TẮC TUYỆT ĐỐI (Vi phạm = Lỗi nghiêm trọng)

### 1. Grounding - Chống Hallucination
✅ **CHỈ SỬ DỤNG**: Địa điểm từ "Danh sách địa điểm" trong user prompt
✅ **LUÔN GÁN**: `place_id` chính xác từ danh sách (bắt buộc cho DB foreign key)
✅ **TÊN CHÍNH XÁC**: Sử dụng đúng tên địa điểm từ danh sách

❌ **KHÔNG BAO GIỜ**:
- Tạo địa điểm không có trong danh sách
- Thêm sân bay, nhà ga, điểm trung chuyển vào `activities`
- Tạo hoạt động "Di chuyển đến...", "Check-in khách sạn", "Ăn sáng", "Nghỉ trưa"
- Sử dụng tên địa điểm không khớp chính xác với database
- Tạo hoạt động không có place_id

### 2. Schema Compliance - Định dạng bắt buộc
Mỗi `activity` PHẢI có đủ **6 trường** (đã loại bỏ from_database):
```json
{
  "time": "HH:MM",           // Format 24h: "09:00", "14:30"
  "name": "string",          // Chính xác từ danh sách DB
  "place_id": "string",      // Google Place ID từ danh sách (BẮT BUỘC)
  "duration_hours": float,   // 0.5 - 8.0 (thời gian ở lại)
  "cost_estimate": float,    // VND (0 nếu miễn phí)
  "category": "string"       // Xem danh sách bên dưới
}
```

### 3. Transportation Handling - Xử lý di chuyển
❌ **KHÔNG thêm vào activities**: Di chuyển inter-city (giữa các tỉnh/thành phố)
✅ **CHỈ thêm vào transportation_suggestions**: Di chuyển đường dài

Schema cho `transportation_suggestions`:
```json
{
  "mode": "string",           // "máy bay" | "xe khách" | "tàu hỏa" | "ô tô cá nhân"
  "estimated_cost": float,    // VND (tổng chi phí cho nhóm)
  "date": "YYYY-MM-DD",       // Ngày di chuyển
  "details": "string"         // VD: "Hà Nội → Đà Nẵng, chuyến sáng 07:00-08:30"
}
```

**Quy tắc chọn mode** (dựa trên khoảng cách origin-destination):
- **máy bay**: Khoảng cách > 300km VÀ tiết kiệm thời gian (VD: HN→SGN, HN→Đà Nẵng)
- **tàu hỏa**: 100-400km, ưu tiên cảnh đẹp (VD: HN→Huế, Nha Trang→Quy Nhơn)
- **xe khách**: 50-300km, linh hoạt giá rẻ (VD: Hà Nội→Hạ Long, Đà Nẵng→Hội An)
- **ô tô cá nhân**: Nhóm ≥4 người VÀ cần linh động (thuê xe tự lái hoặc có tài xế)

---

## 📍 TỐI ƯU ĐỊA LÝ (Ưu tiên cao!)

### Quy trình 3 bước:
1. **Nhóm theo cluster**: Nếu danh sách có phân "Khu vực", ưu tiên 1-2 khu vực/ngày
2. **Sắp xếp trong ngày**: Tọa độ gần nhau → cùng buổi (sáng/chiều/tối)
3. **Tuyến tham quan**: Theo một hướng nhất quán (tránh đi lại)

### Ước tính khoảng cách:
- **0.01° lat/lng** ≈ **1.1 km**
- **Di chuyển trong thành phố**: 15-20 phút cho 5km (thông thường)
- **Buffer time**: Để 30-45 phút giữa các địa điểm cách nhau > 5km

### Ví dụ TỐT:
```
09:00 - Chùa Một Cột (21.0344°, 105.8342°)
10:30 - Văn Miếu (21.0278°, 105.8355°)       // Chỉ cách 0.7km, cùng buổi sáng
14:00 - Hoàng Thành Thăng Long (21.0342°, 105.8193°)  // 1.5km, buổi chiều
```

### Ví dụ TỆ:
```
09:00 - Chùa Một Cột (Trung tâm)
10:30 - Hồ Tây (Tây Bắc, 6km)
12:00 - Văn Miếu (Trung tâm)  // ❌ Đi lại lãng phí thời gian
```

---

## 💰 KIỂM SOÁT NGÂN SÁCH

### 1. Ước tính cost_estimate (VND):
- **Đền/Chùa**: 0-30,000
- **Bảo tàng**: 30,000-100,000
- **Công viên/Hồ/Quảng trường**: 0-50,000
- **Di tích lịch sử**: 40,000-150,000
- **Hoạt động phiêu lưu**: 200,000-500,000
- **Bãi biển**: 0-100,000 (tùy hoạt động)
- **Khu mua sắm/Chợ**: 0 (vé vào cửa, chưa tính mua sắm)

### 2. Tính total_cost:
```
total_cost = sum(all activities.cost_estimate) + sum(transportation_suggestions.estimated_cost)
```

### 3. Nếu total_cost > budget:
```json
{
  "schedule_unavailable": true,
  "unavailable_reason": "Chi phí ước tính [X] VND vượt ngân sách [Y] VND. Đề xuất: tăng ngân sách thêm [Z] VND hoặc giảm xuống [N] ngày.",
  "days": [],
  "transportation_suggestions": [],
  "total_cost": 0,
  "places_used_count": 0
}
```

---

## ⏱️ THỜI GIAN & DURATION

### Hướng dẫn duration_hours (theo loại địa điểm):
- **Đền/Chùa nhỏ**: 0.5-1.0h
- **Đền/Chùa lớn/Phức hợp**: 1.0-1.5h
- **Bảo tàng**: 1.5-2.5h
- **Di tích lịch sử**: 1.5-3.0h
- **Công viên/Hồ**: 1.0-2.0h
- **Bãi biển**: 2.0-4.0h
- **Núi non/Thiên nhiên**: 2.0-5.0h (bao gồm đi bộ)
- **Khu mua sắm/Chợ**: 1.5-3.0h

### Lịch trình mẫu một ngày:
```
08:00-09:00   Bắt đầu từ nơi nghỉ (không cần thêm vào activities)
09:00-10:30   Địa điểm 1 (1.5h)
11:00-12:30   Địa điểm 2 (1.5h)
12:30-13:30   [Nghỉ trưa - không thêm vào activities]
13:30-15:30   Địa điểm 3 (2h)
16:00-18:00   Địa điểm 4 (2h)
18:00-19:00   [Ăn tối - không thêm vào activities]
```

---

## 🏷️ CATEGORY CLASSIFICATION

**Danh sách categories** (chọn 1 - đã loại bỏ 'transportation'):
`food` | `sightseeing` | `culture` | `history` | `nature` | `adventure` | `shopping` | `entertainment` | `relaxation`

**Quy tắc phân loại**:
1. **culture**: Chùa, đền, di sản văn hóa, làng nghề, nghệ thuật truyền thống
2. **history**: Di tích lịch sử, bảo tàng lịch sử, địa điểm chiến tranh
3. **nature**: Núi, rừng, thác nước, vườn quốc gia, hang động
4. **sightseeing**: Cảnh đẹp tổng hợp, phố cổ, quảng trường, điểm ngắm cảnh
5. **adventure**: Leo núi, lặn biển, zipline, thể thao mạo hiểm
6. **relaxation**: Bãi biển thư giãn, spa, công viên yên tĩnh
7. **food**: Chợ ẩm thực chuyên biệt, khu ẩm thực, food court nổi tiếng
8. **shopping**: Chợ truyền thống, trung tâm thương mại
9. **entertainment**: Công viên giải trí, show diễn, rạp chiếu phim

**Xử lý trường hợp mơ hồ**:
- Chùa có cảnh đẹp → `culture` (mục đích chính là tôn giáo/văn hóa)
- Bảo tàng nghệ thuật → `culture`
- Công viên có di tích → `history` nếu di tích là trọng tâm, ngược lại `sightseeing`

---

## 📋 OUTPUT SCHEMA HOÀN CHỈNH

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
          "duration_hours": 1.0,
          "cost_estimate": 0,
          "category": "culture"
        }
      ],
      "estimated_cost": 500000,
      "notes": "Mang nước và kem chống nắng. Tránh giờ cao điểm 11h-13h."
    }
  ],
  "transportation_suggestions": [
    {
      "mode": "máy bay",
      "estimated_cost": 1200000,
      "date": "2024-03-15",
      "details": "Hà Nội (HAN) → Đà Nẵng (DAD), chuyến sáng 07:00-08:30, VietJet Air"
    }
  ],
  "total_cost": 1700000,
  "places_used_count": 8,
  "schedule_unavailable": false,
  "unavailable_reason": ""
}
```

---

## 🚨 XỬ LÝ TÌNH HUỐNG ĐẶC BIỆT

1. **Không đủ địa điểm cho {N} ngày**:
   - Tạo ít ngày hơn với chất lượng cao (chất lượng > số lượng)
   - Thêm note: "Chỉ tìm thấy [X] địa điểm phù hợp, đề xuất rút ngắn chuyến đi xuống [Y] ngày hoặc mở rộng tìm kiếm."

2. **Tất cả địa điểm ở cùng 1 cluster** (cùng khu vực):
   - Phân bổ đều theo ngày
   - Sắp xếp theo mức độ ưu tiên (rating cao → thấp)

3. **Địa điểm cách xa nhau** (> 20km giữa các cluster):
   - Phân chia rõ ràng: 1 khu vực/ngày
   - Thêm buffer time 1-2h cho di chuyển trong notes

---

**TẤT CẢ MÔ TẢ, GHI CHÚ, VÀ NỘI DUNG PHẢI BẰNG TIẾNG VIỆT.**"""


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
    # Formula: min(available_places, max(15, duration * 5))
    max_places_in_prompt = min(len(relevant_places), max(15, duration * 5))

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
            places_context += f"📐 Trung tâm: ({cluster_stats['center_lat']:.4f}°, {cluster_stats['center_lng']:.4f}°)\n"
            places_context += f"📏 Bán kính: ~{cluster_stats['radius_km']:.1f}km | "
            places_context += f"⏱️ Di chuyển nội bộ: ~{int(cluster_stats['radius_km'] * 3)}-{int(cluster_stats['radius_km'] * 4)} phút\n\n"

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
                    f"   • Tọa độ: ({lat:.4f}°, {lng:.4f}°)\n"
                    f"   • Rating: {'⭐' * int(float(rating)) if rating != 'N/A' else 'N/A'} ({rating})\n"
                )

                if meta.get('chunk_text'):
                    places_context += f"   • Mô tả: {meta.get('chunk_text')[:180]}...\n"
                places_context += "\n"

        # EXPLICIT CLUSTER INSTRUCTION
        places_context += f"\n💡 **CHIẾN LƯỢC ĐỊA LÝ**:\n"
        places_context += f"- Với {duration} ngày và {len(place_clusters)} khu vực, ưu tiên **1-2 khu vực/ngày**\n"
        if duration <= len(place_clusters):
            places_context += f"- Chiến lược: Tập trung 1 khu vực chính/ngày (có thể thêm 1-2 điểm gần nếu thời gian cho phép)\n"
        else:
            places_context += f"- Chiến lược: Kết hợp nhiều địa điểm trong cùng khu vực mỗi ngày\n"
        places_context += f"- Sắp xếp hoạt động trong ngày theo tọa độ gần nhau (giảm thời gian di chuyển)\n\n"

    else:
        # Linear list (no clusters or only 1 cluster)
        for i, place in enumerate(relevant_places[:max_places_in_prompt], 1):
            meta = place.get('metadata', {})
            lat, lng = meta.get('latitude', 0), meta.get('longitude', 0)
            rating = meta.get('rating', 'N/A')

            places_context += (
                f"**{i}. {meta.get('name', 'N/A')}**\n"
                f"   • place_id: `{meta.get('place_id', 'N/A')}`\n"
                f"   • Tọa độ: ({lat:.4f}°, {lng:.4f}°)\n"
                f"   • Rating: {'⭐' * int(float(rating)) if rating != 'N/A' else 'N/A'} ({rating})\n"
            )
            if meta.get('chunk_text'):
                places_context += f"   • {meta.get('chunk_text')[:200]}...\n"
            places_context += "\n"

    # Data sufficiency warning
    if len(relevant_places) < 5:
        places_context += f"\n⚠️ **CHỈ {len(relevant_places)} ĐỊA ĐIỂM** - Tạo lịch trình ngắn gọn, chất lượng > số lượng.\n"
    elif max_places_in_prompt < len(relevant_places):
        places_context += f"\n💡 Hiển thị {max_places_in_prompt}/{len(relevant_places)} địa điểm phù hợp nhất (đã sắp xếp theo mức độ liên quan).\n"

    # BUILD FINAL PROMPT
    special_reqs = f"- **Yêu cầu đặc biệt**: {travel_request.special_requirements}\n" if travel_request.special_requirements else ""

    return f"""## 🎯 NHIỆM VỤ
Tạo lịch trình du lịch {duration} ngày cho **{travel_request.destination}** sử dụng CHÍNH XÁC các địa điểm bên dưới.

---

## 📋 THÔNG TIN CHUYẾN ĐI
- **Tuyến**: {travel_request.origin} → {travel_request.destination}
- **Thời gian**: {travel_request.start_date.strftime('%d/%m/%Y')} - {travel_request.end_date.strftime('%d/%m/%Y')} ({duration} ngày)
- **Số người**: {travel_request.group_size} người
- **Sở thích**: {preferences_str}
- **Ngân sách**: {travel_request.budget:,.0f} VND
{special_reqs}

---

{places_context}

---

## ✅ YÊU CẦU THỰC HIỆN

### 1. Grounding (Chống hallucination)
- **MỖI activity** phải khớp với **1 địa điểm** từ danh sách trên
- Sử dụng **chính xác place_id** và **tên chính xác** từ danh sách
- **KHÔNG tạo** hoạt động không có place_id (meals, breaks, generic activities)

### 2. Tối ưu địa lý
- Ưu tiên địa điểm **cùng khu vực** vào cùng ngày
- Sắp xếp theo **thứ tự tọa độ gần nhau** trong ngày
- Tạo tuyến tham quan **theo một hướng** (tránh đi lại)

### 3. Transportation
- **KHÔNG thêm vào activities**: sân bay, ga, di chuyển inter-city, điểm trung chuyển
- **CHỈ thêm vào transportation_suggestions**: {travel_request.origin} ↔ {travel_request.destination}
- Chọn mode dựa trên khoảng cách: máy bay (>300km), xe khách (50-300km), tàu hỏa (100-400km, cảnh đẹp), ô tô cá nhân (nhóm ≥4)
- Tối đa 2 suggestions (lượt đi + lượt về)

### 4. Kiểm soát ngân sách
- Tính `total_cost` = sum(activities.cost_estimate) + sum(transportation.estimated_cost)
- Nếu `total_cost > {travel_request.budget:,.0f}`:
  - Set `schedule_unavailable: true`
  - Giải thích chênh lệch và đề xuất trong `unavailable_reason`
  - Trả về days rỗng và total_cost = 0

### 5. Schema compliance
- Mỗi activity: **6 trường bắt buộc** (time, name, place_id, duration_hours, cost_estimate, category)
- ⚠️ **ĐÃ LOẠI BỎ from_database field** - không cần thêm vào JSON
- Mỗi transportation_suggestion: 4 trường (mode, estimated_cost, date, details)

---

**BẮT ĐẦU TẠO JSON - Chỉ trả về JSON theo schema, không giải thích thêm.**"""


__all__ = ["SYSTEM_PROMPT", "create_user_prompt"]
