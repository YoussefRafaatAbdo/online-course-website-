FROM python:latest 

WORKDIR /app

COPY . . 
EXPOSE 5000

CMD ["python3", "-m", "http.server", "5000"]