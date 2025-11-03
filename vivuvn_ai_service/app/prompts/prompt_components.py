"""
Prompt components for building system prompts.
Separated from travel_prompts.py for reuse and maintainability.
"""

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
  "cost_estimate": 50000,    // VND, 0 nếu free, ước lượng chi phí cho hoạt động
  "notes": "..."             // 15-30 từ tiếng Việt
}
```

### Transportation (CHỈ trong transportation_suggestions)
KHÔNG thêm vào activities | Tối đa 2 suggestions | Cost = TOTAL cho nhóm

**Xử lý transportation_mode của user:**
- Kiểm tra: Phương tiện user chọn có hợp lý với route không?
- Nếu hợp lý: Accept + tạo suggestions theo lựa chọn
- Nếu không hợp lý: Suggest phương tiện hợp hơn (kèm lý do trong details)
- Luôn tôn trọng lựa chọn nhưng ưu tiên giải pháp thực thế

## CÂY QUYẾT ĐỊNH
    Kiểm tra thời tiết → Lọc an toàn → Kiểm chứng phương tiện → Khớp yêu cầu → Sắp xếp sở thích → Vừa ngân sách → Tối ưu địa lý
"""

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
  "details": "Hà Nội-Đà Nẵng, 07:00-21:00 (14h)"
}
```
*Format: Từ-Đến, giờ bắt đầu-giờ kết thúc (tổng thời gian) (lý do thay đổi transportation_mode nếu có). Không lặp lại route.*
"""

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
- Thiên nhiên: Núi, thác, rừng, hang động, công viên quốc gia
- Phiêu lưu: Zipline, trekking, leo núi, lặn, paragliding, cáp treo
- Văn hóa: Đền, chùa, làng nghề, hội làng, biểu diễn
- Lịch sử: Bảo tàng, di tích, thành cổ, đài tưởng niệm
- Ẩm thực: Chợ, phố ẩm thực, nhà hàng đặc sản
- Biển: Bãi biển, đảo, resort
- Nhiếp ảnh: View đẹp, sunrise/sunset, kiến trúc, ruộng bậc thang
- Mua sắm: Chợ, trung tâm thương mại
- Đời sống về đêm: Phố đi bộ, bar street, chợ đêm

**Ví dụ áp dụng:**
- ["Thiên nhiên", "Phiêu lưu"] (6 acts) → 4: núi/thác/trek/zipline, 2: văn hóa/chợ
- ["Văn hóa", "Lịch sử"] (6 acts) → 4-5: đền/chùa/bảo tàng, 1-2: ẩm thực
- ["Ẩm thực", "Nhiếp ảnh"] (5 acts) → 3-4: chợ/nhà hàng/view, 1-2: di tích"""

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

    TRANSPORTATION_VALIDATION = """## KIỂM CHỨNG PHƯƠNG TIỆN DI CHUYỂN

**Routes có Máy bay (Có sân bay):**
HN↔TPHCM | HN↔ĐN | HN↔Nha Trang | HN↔Phú Quốc | HN↔Cần Thơ | HN↔Quy Nhơn | HN↔Pleiku
TPHCM↔ĐN | TPHCM↔Huế | TPHCM↔Nha Trang | TPHCM↔Phú Quốc | TPHCM↔Cần Thơ | TPHCM↔Đà Lạt
ĐN↔Nha Trang | ĐN↔Phú Quốc

**Routes có Tàu hỏa (Có đường ray):**
HN↔TPHCM (Thống Nhất SE) | HN↔Huế | HN↔Hải Phòng | HN↔Lào Cai
Huế↔TPHCM | ĐN↔Huế

**Rules - Validation Soft (Chỉ suggest nếu không hợp lý):**
1. Máy bay hợp lý? → Check: Route trong danh sách "có máy bay" + khoảng cách >300km
2. Tàu hợp lý? → Check: Route trong danh sách "có tàu hỏa"
3. Xe khách/ô tô hợp lý? → Luôn hợp lý (all-in-one)
4. Xe máy hợp lý? → <150km, chỉ đi trong ngày

**Nếu user chọn phương tiện KHÔNG hợp lý:**
- Suggest phương tiện hợp lý hơn trong transportation_suggestions
- Reason: (VD: "Không có sân bay", "Rẻ hơn", "Thoải mái hơn")
- Ví dụ: User "máy bay" HN→Hà Giang (không có sân bay) → Suggest "xe khách" + reason"""

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


__all__ = ["PromptComponents"]
