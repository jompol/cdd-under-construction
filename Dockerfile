FROM nginx:alpine

# Copy static files for web (port 80)
COPY index.html /usr/share/nginx/html/
COPY favicon.svg /usr/share/nginx/html/

# Copy static files for admin (port 81)
RUN mkdir -p /usr/share/nginx/html/admin
COPY admin.html /usr/share/nginx/html/admin/
COPY favicon.svg /usr/share/nginx/html/admin/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 81

CMD ["nginx", "-g", "daemon off;"]
