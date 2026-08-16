# Stage 1: Build (Debian Slim)
FROM node:20-slim AS frontend-builder
WORKDIR /app

# 1. Nur package.json kopieren
COPY service-frontend/package.json ./

# 2. ALLE Dependencies (inkl. devDependencies wie cross-env & vite) installieren
RUN npm install --include=dev

# 3. Environment erst NACH der Installation auf production setzen
ENV NODE_ENV=production

# 4. Source-Code kopieren
COPY service-frontend/ .

# 5. Build ausführen
RUN npm run build


# Stage 2: Nginx Webserver
FROM nginx:alpine
RUN rm -rf /etc/nginx/conf.d/* /etc/nginx/nginx.conf

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=frontend-builder /app/dist /usr/share/nginx/html
COPY nginx/html/ /usr/share/nginx/html/errors/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]