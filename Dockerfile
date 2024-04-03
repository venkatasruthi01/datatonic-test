FROM python:3.8-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir flask

EXPOSE 80

ENV NAME World

CMD ["python", "app.py"]
