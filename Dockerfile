# ============================================
# ECourses - Optimized Nginx Static Site Image
# Replaces: python:latest (800MB+) → nginx:alpine (~25MB)
# ============================================

FROM nginx:alpine

# Remove default nginx placeholder page
RUN rm -rf /usr/share/nginx/html/*

# Copy all static site files into nginx's web root
COPY . /usr/share/nginx/html/

# Optional: custom nginx config for better performance
RUN echo 'server { \
    listen 80; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
    # Enable gzip compression \
    gzip on; \
    gzip_types text/css application/javascript image/svg+xml; \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
