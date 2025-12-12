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
  "cost_estimate": 50000,    // VND cho CẢ NHÓM (per person × group_size), 0 nếu free
  "notes": "..."             // 15-30 từ tiếng Việt
}
```

### Transportation (CHỈ trong transportation_suggestions)
KHÔNG thêm vào activities | Tối đa 2 suggestions | Cost = TOTAL cho nhóm (tổng chi phí cho tất cả thành viên, KHÔNG chia per person)

**Xử lý transportation_mode của user:**
- Kiểm tra: Phương tiện user chọn có hợp lý với route không?
- Nếu hợp lý: tạo suggestions theo lựa chọn
- Nếu không hợp lý: Suggest phương tiện hợp hơn (kèm lý do trong details)
- Luôn ưu tiên lựa chọn phương tiện di chuyển của người dùng nhưng chọn giải pháp khác khi phương tiện di chuyển không pass validation

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

**Transportation (max 2):**
```json
{
  "mode": "xe khách",
  "estimated_cost": 2000000,
  "date": "2024-03-15",
  "details": "Hà Nội → Đà Nẵng, 07:00-21:00 (14h)"
}
```

**Example: Transportation warning (LLM tự tạo, không có icon)**
User chọn "máy bay", route HN → Hà Giang
```json
{
  "transportation_suggestions": [{
    "mode": "xe khách",
    "estimated_cost": 400000,
    "date": "2024-03-15",
    "details": "Hà Nội → Hà Giang, 06:00-12:00 (6h)"
  }],
  "warnings": [
    "Phương tiện di chuyển: Hà Giang không có sân bay, nên chúng tôi đề xuất xe khách thay vì máy bay để bạn có thể di chuyển thuận tiện hơn."
  ]
}
```

**Example: Cost warning (Backend tạo, không có icon)**
Budget: 10,000,000 VND, Total cost: 10,500,000 VND
```json
{
  "total_cost": 10500000,
  "schedule_unavailable": true,
  "unavailable_reason": "Tổng chi phí 10,500,000 VND vượt ngân sách 10,000,000 VND",
  "warnings": [
    "Chi phí vượt ngân sách: 10,500,000 VND (vượt 500,000 VND so với ngân sách 10,000,000 VND). Bạn có thể cần điều chỉnh lịch trình hoặc tăng ngân sách."
  ]
}
```

**Lưu ý:**
- KHÔNG CÓ field unavailable_reason nữa
- Khi schedule_unavailable=true: warnings[0] chứa lý do chặn
- Khi schedule_unavailable=false: warnings chứa cảnh báo không chặn
- Text thuần bằng tiếng Việt, không icon
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

**Rules - Validation Hard (Chỉ suggest nếu pass validation):**
1. Máy bay không pass validation khi: Route không có trong danh sách "Có sân bay" + khoảng cách <150km
2. Tàu không pass validation khi: Route không có trong danh sách "Có đường ray"
3. Xe khách/ô tô không pass validation khi tổng thời gian di chuyển từ điểm xuất phát đến điểm đến và ngược lại lớn hơn travel duration (end date - start date)
4. Xe máy không pass validation khi: quãng đường >500km hoặc thời gian di chuyển >24h, tổng thời gian di chuyển từ điểm xuất phát đến điểm đến và ngược lại lớn hơn travel duration (end date - start date)

**Nếu phương tiện user chọn KHÔNG pass validation:**
- Suggest: phương tiện tối ưu cho chuyến đi
- ADD TO warnings: Tạo message thân thiện BẰNG TIẾNG VIỆT giải thích tại sao thay đổi
  * KHÔNG dùng icon, chỉ text thuần
  * Giải thích rõ ràng lý do (không có sân bay/ga, quãng đường xa, thời gian chuyến đi, etc.)
  * Giọng điệu thân thiện, lịch sự, chuyên nghiệp
  * Đề xuất phương tiện phù hợp hơn
  * Ví dụ: "Phương tiện di chuyển: Hà Giang không có sân bay, nên chúng tôi đề xuất xe khách thay vì máy bay để bạn có thể di chuyển thuận tiện hơn."
- details CHỈ ghi: "Route, giờ xuất phát-giờ đến (tổng thời gian)"
  * Ví dụ: "Hà Nội → Hà Giang, 06:00-12:00 (6h)"
  * KHÔNG ghi lý do trong details

**Nếu tổng thời gian di chuyển lớn hơn travel duration:** 
- schedule_unavailable=true
- unavailable_reason: giải thích + đề xuất

**Ngày khởi hành:** Điều chỉnh ngày khởi hành sao cho phù hợp với thời gian di chuyển của phương tiện đã chọn."""

    BUDGET_STRATEGY = """## CHIẾN LƯỢC NGÂN SÁCH

**Tiers (VND/người/ngày):**
- **Tiết kiệm** (<500k): Max địa điểm free, tối đa 1-2 có phí thấp/ngày
- **Trung bình** (500k-1.5M): 50-60% free + 40-50% có phí (bảo tàng, di tích)
- **Thoải mái** (1.5M-3M): Hoạt động phí cao OK (cáp treo, tour đặc sắc)
- **Cao cấp** (>3M): Ưu tiên premium (zipline, helicopter, cruise)

**Cost reference (VND per person - PHẢI NHÂN với group_size khi tính cost_estimate):**
Đền/Chùa: 0-20k | Bảo tàng: 40-80k | Di tích: 50-120k | Phiêu lưu: 200-500k | Biển: 0-50k

**Calculation example (4 người):**
- Bảo tàng: 50k/người × 4 người = 200,000 VND → cost_estimate = 200000
- Chùa free: 0 × 4 người = 0 VND → cost_estimate = 0

**Formula:**
total_cost = sum(activity.cost_estimate) + sum(transport.estimated_cost)

Note: Both activity cost_estimate and transportation estimated_cost are TOTAL for entire group

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

**Quy tắc validation:**
- Tối thiểu 3 hoạt động/ngày (khuyến nghị, có thể giảm nếu thiếu dữ liệu)
- place_id hợp lệ từ danh sách
- total_cost ≤ budget (ràng buộc cứng)

**Lỗi nghiêm trọng (schedule_unavailable=true):**
1. **Vượt ngân sách:** 
   - Đặt schedule_unavailable=true
   - Thêm vào warnings[0]: "Chi phí vượt ngân sách: X VND vượt quá ngân sách Y VND. Bạn có thể cần điều chỉnh lịch trình hoặc tăng ngân sách."

2. **Thiếu địa điểm (<2 địa điểm/ngày):**
   - Đặt schedule_unavailable=true
   - Thêm vào warnings[0]: "Không đủ địa điểm: Chỉ có X địa điểm cho Y ngày. Đề xuất giảm số ngày hoặc mở rộng vùng tìm kiếm."

3. **Thời gian di chuyển > thời gian chuyến đi:**
   - Đặt schedule_unavailable=true
   - Thêm vào warnings[0]: "Thời gian di chuyển quá dài: X giờ vượt quá thời gian chuyến đi Y ngày. Đề xuất tăng số ngày hoặc chọn điểm đến gần hơn."

**Vấn đề không chặn (schedule_unavailable=false, thêm vào warnings):**
1. **Đổi phương tiện di chuyển:** Giải thích lý do bằng tiếng Việt, text thuần
2. **Khớp sở thích thấp:** (tùy chọn) Ghi chú trong warnings
3. **Không có dữ liệu thời tiết:** (tùy chọn) Ghi chú trong warnings

**Quan trọng:** 
- KHÔNG CÒN field unavailable_reason
- Khi schedule_unavailable=true: Đặt lý do chặn vào warnings[0]
- Khi schedule_unavailable=false: Đặt cảnh báo không chặn vào warnings

**Output:** JSON theo schema TravelItinerary | MỌI text tiếng Việt"""


__all__ = ["PromptComponents"]
