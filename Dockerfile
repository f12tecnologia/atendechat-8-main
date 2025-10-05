# Etapa 1: build da aplicação
FROM node:20-alpine AS builder

WORKDIR /app

# Copia arquivos essenciais
COPY package*.json ./

# Instala dependências (somente as necessárias para build)
RUN npm ci

# Copia o código fonte
COPY . .

# Compila o TypeScript para JavaScript
RUN npx tsc

# Etapa 2: imagem final leve para execução
FROM node:20-alpine

WORKDIR /app

# Copia apenas o build e dependências necessárias para rodar
COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

# Define variável de ambiente (opcional)
ENV NODE_ENV=production

# Porta exposta (ajuste conforme seu app)
EXPOSE 3000

# Comando padrão
CMD ["node", "dist/index.js"]
