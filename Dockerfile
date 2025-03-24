# Use an official Node.js image to build the React app
FROM node:18 as build

# Add build arguments
ARG NODE_ENV=production
ARG BUILD_DATE
ARG VERSION

# Add labels
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.description="React Todo List Application"

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY . .

# Build the application
ENV NODE_ENV=${NODE_ENV}
RUN npm run build

# Use a lightweight web server for production
FROM nginx:alpine

# Copy built files from builder stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
