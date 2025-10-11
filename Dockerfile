# Stage 1: Build de l'application React
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Servir avec Nginx
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

# Si tu as un fichier nginx.conf personnalisé, décommente cette ligne :
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
