# 1. Вибираємо базовий образ на основі Debian
FROM python:3.11.12-bookworm

# 2. Оновлюємо систему та встановлюємо системні залежності
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 3. Створюємо користувача для запуску застосунку
RUN useradd -m -d /home/app app
USER app

# 4. Встановлюємо змінну середовища PATH
ENV PATH="${PATH}:/home/app/.local/bin"

# 5. Встановлюємо робочий каталог
WORKDIR /home/app/src

# 6. Спочатку копіюємо лише файл із залежностями (часто не змінюється)
COPY requirements.txt .

# 7. Встановлюємо Python-залежності
RUN pip install --no-cache-dir -r requirements.txt

# 8. Копіюємо увесь код проєкту (змінюється частіше)
COPY . .

# 9. Відкриваємо порт, який використовує сервер
EXPOSE 8080

# 10. Вказуємо команду для запуску застосунку
CMD ["uvicorn", "spaceship.main:app", "--host=0.0.0.0", "--port=8080"]
