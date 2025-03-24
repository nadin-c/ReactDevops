# 🌟 Stage 1: Build the React App
FROM node:18 as build

# Add build arguments
ARG BUILD_DATE
ARG VERSION

# Add labels
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.description="React Todo List Application"

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install all dependencies, including devDependencies
RUN npm install --include=dev

# Copy source files
COPY . .

# Build the application
RUN npm run build

# 🌟 Stage 2: Serve with NGINX
FROM nginx:alpine

# Set working directory for NGINX
WORKDIR /usr/share/nginx/html

# Remove default NGINX static files
RUN rm -rf ./*

# Copy built files from the build stage
COPY --from=build /app/dist .

# Copy custom NGINX configuration (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
