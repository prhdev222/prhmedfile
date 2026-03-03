# Deploy บน Koyeb (Flask + Neon + Cloudinary)

วิธี deploy โปรเจกต์นี้บน Koyeb แบบฟรี

---

## สิ่งที่ต้องมีก่อน

1. **GitHub** – โค้ดโปรเจกต์อยู่ใน repo
2. **Neon** – สร้าง project แล้ว copy **Connection string** (PostgreSQL)
3. **Cloudinary** – สร้าง cloud แล้ว copy **CLOUDINARY_URL** (หรือ cloud name + api key + api secret)

---

## ขั้นตอน Deploy

### 1. สมัคร / Login Koyeb

- ไปที่ [koyeb.com](https://www.koyeb.com) → Sign up (ใช้ GitHub ได้)

### 2. สร้าง Service ใหม่

- คลิก **Create App** หรือ **Create Service**
- เลือก **Docker** (ไม่ใช่ Git build แบบไม่มี Dockerfile)
- **Source**: เลือก **GitHub** แล้วเลือก repo โปรเจกต์นี้
- **Branch**: `main` (หรือ branch ที่ใช้ deploy)
- **Builder**: Dockerfile  
  - ให้ Koyeb ใช้ **Dockerfile** ที่อยู่ใน repo (โฟลเดอร์ root)

### 3. ตั้งค่า Environment Variables

ใน Koyeb ไปที่ **Service → Configuration → Environment variables** แล้วเพิ่ม:

| ชื่อตัวแปร | ค่าที่ใส่ | หมายเหตุ |
|------------|----------|----------|
| `DATABASE_URL` | Connection string จาก Neon | ตัวอย่าง `postgresql://user:pass@ep-xxx.neon.tech/dbname?sslmode=require` |
| `CLOUDINARY_URL` | จาก Cloudinary Dashboard | รูปแบบ `cloudinary://api_key:api_secret@cloud_name` |
| `SECRET_KEY` | สร้างรหัสยาว ๆ เอง | ใช้สำหรับ session (เช่น `openssl rand -hex 32`) |
| `ADMIN_USERNAME` | ชื่อ admin | ตัวเลือก |
| `ADMIN_PASSWORD` | รหัส admin | ตัวเลือก (ควรเปลี่ยนจากค่า default) |
| `ADMIN_EMAIL` | อีเมล admin | ตัวเลือก |

- **PORT** ไม่ต้องใส่ — Koyeb จะใส่ให้อัตโนมัติ

### 4. Deploy

- กด **Deploy**  
- รอ build และ start เสร็จ จะได้ URL ประมาณ `https://your-app-name-xxx.koyeb.app`

### 5. หลัง Deploy ครั้งแรก

- แอปจะรัน `init_db()` เอง (สร้างตาราง + seed departments + admin)
- ลองเข้า URL ที่ได้ → หน้าหลัก
- เข้า `/admin/login` แล้ว login ด้วย `ADMIN_USERNAME` / `ADMIN_PASSWORD` ที่ตั้งใน env

---

## หมายเหตุ

- **Neon**: ถ้าได้ connection string เป็น `postgres://...` โค้ดจะแปลงเป็น `postgresql://` ให้อัตโนมัติ
- **Cloudinary**: ต้องมี `CLOUDINARY_URL` ถึงจะอัปโหลดรูป/ไฟล์ได้
- **Free tier**: ตรวจสอบข้อจำกัดของ Koyeb free tier ที่ [Koyeb Pricing](https://www.koyeb.com/pricing)

---

## ถ้า Deploy ไม่ผ่าน

1. ดู **Logs** ใน Koyeb ว่าขึ้น error อะไร (เช่น ขาด env, DB เชื่อมไม่ได้)
2. ตรวจสอบว่าใน Neon เปิด **Allow external connections** / ไม่ block IP
3. ตรวจสอบว่า `DATABASE_URL` กับ `CLOUDINARY_URL` คัดลอกครบ ไม่มีช่องว่างหรือตัวอักษรหาย
