# Base image
FROM python:3.9

# Working directory set karo
WORKDIR /app

# System dependencies install karo (MySQL client libraries ke liye)
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file pehle (cache ke liye)
COPY requirements.txt .

# Python dependencies install karo
RUN pip install --no-cache-dir -r requirements.txt

# Copy baki sari files including .env
COPY . .

# (Optional) python-dotenv pehle se requirements.txt me add kar do, yaha dobara install karne ki zarurat nahi
# RUN pip install python-dotenv

# Django static files collect karo (agar static files hain toh)
RUN python manage.py collectstatic --noinput || true

# Port expose karo
EXPOSE 8000

# Run Django development server (production ke liye gunicorn use karo)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
