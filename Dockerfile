# ----------------------------
# 1️⃣ Base Image
# ----------------------------
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# ----------------------------
# 2️⃣ Install Dependencies
# ----------------------------
FROM base AS deps
RUN npm ci

# ----------------------------
# 3️⃣ Build Application
# ----------------------------
FROM deps AS builder
COPY . .
RUN npm run build

# ----------------------------
# 4️⃣ Production Image
# ----------------------------
FROM node:18-alpine AS runner
WORKDIR /app

# Copy built app and static files from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Expose the application port
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
