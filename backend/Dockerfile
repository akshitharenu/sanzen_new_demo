FROM node:20-alpine

WORKDIR /app

# Install dependencies for native modules
RUN apk add --no-cache python3 make g++

COPY package*.json ./
RUN npm ci

COPY . .

# Generate Prisma client
RUN npx prisma generate

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
