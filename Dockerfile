# ---- build stage ----
FROM oven/bun:1 AS build
WORKDIR /app

# Copy repo
COPY . .

# Install dependencies (monorepo)
RUN bun install

# Build the Next.js app
WORKDIR /app/apps/web
RUN bun run build

# ---- run stage ----
FROM oven/bun:1 AS run
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=10000

# Copy built app + deps
COPY --from=build /app /app

WORKDIR /app/apps/web
EXPOSE 10000

# Next.js start (works when build output exists)
CMD ["bun", "run", "start", "--", "-p", "10000"]
