FROM nginx:alpine

# Pastikan kamu sudah jalankan 'flutter build web' di laptop
# Folder build/web akan di-copy ke folder web server Nginx
COPY ./build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]