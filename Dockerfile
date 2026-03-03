# ใช้ image Python ล่าสุด
FROM python:3.12-slim

# ตั้ง working directory
WORKDIR /app

# ติดตั้ง dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# คัดลอกโค้ดแอป
COPY . .

# Koyeb ใช้ PORT จาก env
ENV PORT=8000
EXPOSE 8000

# รันด้วย gunicorn (production)
CMD gunicorn --bind 0.0.0.0:${PORT} --workers 1 --threads 2 --timeout 120 app:app
