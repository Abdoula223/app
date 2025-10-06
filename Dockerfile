#
# FICHIER CORRIGÉ : backend/Dockerfile (Version Production)
#
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

# Installe uniquement les dépendances de production
RUN npm ci --only=production

COPY . .

EXPOSE 5000

# Utilise la commande de démarrage stable pour la production
CMD ["npm", "start"]
