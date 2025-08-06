# Builder stage
FROM python:3.10-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --prefix=/install -r requirements.txt

COPY app /app/app

# Final stage
FROM python:3.10-slim AS runtime

WORKDIR /app
COPY --from=builder /install /usr/local
COPY --from=builder /app /app

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]