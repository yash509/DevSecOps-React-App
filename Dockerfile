# Use official Node.js image as base
FROM node:14-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json if available to work directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files and folders to the current working directory (i.e. root folder of the app)
COPY . .

# Build the React app for production
RUN npm run build

# Use NGINX as a lightweight web server to serve the static content
FROM nginx:alpine

# Copy the built React app from the build stage to the NGINX html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start NGINX server when the container starts
CMD ["nginx", "-g", "daemon off;"]
